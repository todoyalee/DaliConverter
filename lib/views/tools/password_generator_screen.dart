import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:daliconverter/utils/app_theme.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double _length = 16;
  bool _useUpper = true;
  bool _useLower = true;
  bool _useDigits = true;
  bool _useSymbols = true;
  bool _excludeSimilar = false; // O0o, l1I|, etc.
  bool _excludeAmbiguous = false; // ambiguous punctuation
  bool _obscure = false;

  String _password = '';
  List<String> _saved = [];

  @override
  void initState() {
    super.initState();
    _loadSaved();
    _generate();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _saved = prefs.getStringList('saved_passwords') ?? [];
    });
  }

  Future<void> _persistSaved() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_passwords', _saved);
  }

  void _applyPreset(String preset) {
    switch (preset) {
      case 'PIN':
        setState(() {
          _length = 6;
          _useUpper = false;
          _useLower = false;
          _useDigits = true;
          _useSymbols = false;
          _excludeSimilar = false;
          _excludeAmbiguous = false;
        });
        break;
      case 'Short':
        setState(() {
          _length = 12;
          _useUpper = true;
          _useLower = true;
          _useDigits = true;
          _useSymbols = false;
          _excludeSimilar = false;
          _excludeAmbiguous = false;
        });
        break;
      case 'Strong':
        setState(() {
          _length = 16;
          _useUpper = true;
          _useLower = true;
          _useDigits = true;
          _useSymbols = true;
          _excludeSimilar = false;
          _excludeAmbiguous = false;
        });
        break;
      case 'Paranoid':
        setState(() {
          _length = 24;
          _useUpper = true;
          _useLower = true;
          _useDigits = true;
          _useSymbols = true;
          _excludeSimilar = true;
          _excludeAmbiguous = true;
        });
        break;
    }
    _generate();
  }

  void _generate() {
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';
    const symbols = "!@#\$%^&*()_-+=[]{};:,.<>?~`|\\/"; // richer set

    const similar = 'O0oIl1|S5B8Z2';
    const ambiguous = "{}[]()/\\'\"`~,;:.<>";

    String sanitize(String source) {
      String s = source;
      if (_excludeSimilar) {
        s = s.split('').where((c) => !similar.contains(c)).join();
      }
      if (_excludeAmbiguous) {
        s = s.split('').where((c) => !ambiguous.contains(c)).join();
      }
      return s;
    }

    String pool = '';
    String u = _useUpper ? sanitize(upper) : '';
    String l = _useLower ? sanitize(lower) : '';
    String d = _useDigits ? sanitize(digits) : '';
    String s = _useSymbols ? sanitize(symbols) : '';
    pool = u + l + d + s;

    if (pool.isEmpty) {
      setState(() => _password = '');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one character set')),
      );
      return;
    }

    final secure = Random.secure();

    // Ensure at least one from each selected set
    List<String> chars = [];
    if (u.isNotEmpty) chars.add(u[secure.nextInt(u.length)]);
    if (l.isNotEmpty) chars.add(l[secure.nextInt(l.length)]);
    if (d.isNotEmpty) chars.add(d[secure.nextInt(d.length)]);
    if (s.isNotEmpty) chars.add(s[secure.nextInt(s.length)]);

    while (chars.length < _length.round()) {
      chars.add(pool[secure.nextInt(pool.length)]);
    }

    // Shuffle
    for (int i = chars.length - 1; i > 0; i--) {
      final j = secure.nextInt(i + 1);
      final tmp = chars[i];
      chars[i] = chars[j];
      chars[j] = tmp;
    }

    setState(() => _password = chars.join());
  }

  Future<void> _copy([String? value]) async {
    final text = value ?? _password;
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    }
  }

  void _toggleSave() {
    if (_password.isEmpty) return;
    setState(() {
      if (_saved.contains(_password)) {
        _saved.remove(_password);
      } else {
        _saved.insert(0, _password);
      }
    });
    _persistSaved();
  }

  void _removeSaved(String p) {
    setState(() => _saved.remove(p));
    _persistSaved();
  }

  (String label, double score, Color color) _strength(String value) {
    if (value.isEmpty) {
      return ('', 0.0, Colors.grey);
    }
    int variety = 0;
    if (RegExp(r'[A-Z]').hasMatch(value)) variety++;
    if (RegExp(r'[a-z]').hasMatch(value)) variety++;
    if (RegExp(r'[0-9]').hasMatch(value)) variety++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) variety++;

    double lengthScore = (value.length / 20).clamp(0.0, 1.0);
    double varietyScore = variety / 4;

    double score = (lengthScore * 0.6 + varietyScore * 0.4).clamp(0.0, 1.0);
    if (score < 0.34) return ('Weak', score, Colors.red);
    if (score < 0.67) return ('Medium', score, Colors.orange);
    return ('Strong', score, Colors.green);
  }

  double _entropyBits() {
    int poolSize = 0;
    if (_useUpper) poolSize += 26;
    if (_useLower) poolSize += 26;
    if (_useDigits) poolSize += 10;
    if (_useSymbols) poolSize += 28; // approx
    if (_excludeSimilar) poolSize -= 10;
    if (_excludeAmbiguous && _useSymbols) poolSize -= 10;
    if (poolSize < 1) return 0;
    return _length * (log(poolSize) / log(2));
  }

  @override
  Widget build(BuildContext context) {
    final (label, strength, color) = _strength(_password);
    final entropy = _entropyBits();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPasswordCard(
                        context, label, strength, color, entropy),
                    SizedBox(height: 2.h),
                    _buildPresetsRow(context),
                    SizedBox(height: 1.5.h),
                    _buildOptionsCard(context),
                    if (_saved.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      _buildSavedList(context),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getPrimaryColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Password Generator',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(BuildContext context, String label, double strength,
      Color color, double entropy) {
    final isSaved = _saved.contains(_password);
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getPrimaryColor(context).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.password,
                      color: AppTheme.getPrimaryColor(context)),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Your Password',
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _generate,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Regenerate',
                ),
                IconButton(
                  onPressed: _copy,
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy',
                ),
                IconButton(
                  onPressed: _toggleSave,
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
                  color: isSaved ? AppTheme.getPrimaryColor(context) : null,
                  tooltip: isSaved ? 'Unsave' : 'Save',
                ),
              ],
            ),
            SizedBox(height: 1.2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SelectableText(
                      _password.isEmpty
                          ? 'Tap refresh to generate'
                          : (_obscure ? '•' * _password.length : _password),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.getTextPrimaryColor(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility),
                    tooltip: _obscure ? 'Show' : 'Hide',
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.2.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: strength,
                      minHeight: 10,
                      backgroundColor: Theme.of(context).dividerColor,
                      color: color,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label.isEmpty ? '—' : label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.8.h),
            Text(
              'Entropy: ${entropy.toStringAsFixed(1)} bits',
              style: TextStyle(
                color: AppTheme.getTextSecondaryColor(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsRow(BuildContext context) {
    Widget chip(String label, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: AppTheme.getPrimaryColor(context).withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.getPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip('PIN', () => _applyPreset('PIN')),
        SizedBox(width: 2.w),
        chip('Short', () => _applyPreset('Short')),
        SizedBox(width: 2.w),
        chip('Strong', () => _applyPreset('Strong')),
        SizedBox(width: 2.w),
        chip('Paranoid', () => _applyPreset('Paranoid')),
      ],
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options',
              style: TextStyle(
                color: AppTheme.getTextPrimaryColor(context),
                fontWeight: FontWeight.w700,
                fontSize: 12.5.sp,
              ),
            ),
            SizedBox(height: 1.2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Length: ${_length.round()}',
                    style: TextStyle(
                        color: AppTheme.getTextSecondaryColor(context))),
                TextButton(
                  onPressed: () => setState(() => _length = 16),
                  child: const Text('Reset'),
                )
              ],
            ),
            Slider(
              value: _length,
              min: 6,
              max: 64,
              divisions: 58,
              label: _length.round().toString(),
              onChanged: (v) => setState(() => _length = v),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Uppercase'),
                  selected: _useUpper,
                  onSelected: (v) => setState(() => _useUpper = v),
                ),
                FilterChip(
                  label: const Text('Lowercase'),
                  selected: _useLower,
                  onSelected: (v) => setState(() => _useLower = v),
                ),
                FilterChip(
                  label: const Text('Numbers'),
                  selected: _useDigits,
                  onSelected: (v) => setState(() => _useDigits = v),
                ),
                FilterChip(
                  label: const Text('Symbols'),
                  selected: _useSymbols,
                  onSelected: (v) => setState(() => _useSymbols = v),
                ),
                FilterChip(
                  label: const Text('Exclude similar'),
                  selected: _excludeSimilar,
                  onSelected: (v) => setState(() => _excludeSimilar = v),
                ),
                FilterChip(
                  label: const Text('Exclude ambiguous'),
                  selected: _excludeAmbiguous,
                  onSelected: (v) => setState(() => _excludeAmbiguous = v),
                ),
              ],
            ),
            SizedBox(height: 1.2.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.bolt),
                    label: const Text('Regenerate'),
                  ),
                  SizedBox(width: 2.w),
                  OutlinedButton.icon(
                    onPressed: _copy,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                  SizedBox(width: 2.w),
                  OutlinedButton.icon(
                    onPressed: _toggleSave,
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedList(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Saved Passwords',
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ),
                if (_saved.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() => _saved.clear());
                      _persistSaved();
                    },
                    child: const Text('Clear All'),
                  )
              ],
            ),
            ..._saved.map((p) => Container(
                  margin: EdgeInsets.only(top: 1.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          p,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.getTextPrimaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _copy(p),
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy',
                      ),
                      IconButton(
                        onPressed: () => _removeSaved(p),
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
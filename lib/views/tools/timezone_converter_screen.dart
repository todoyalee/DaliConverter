import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:daliconverter/utils/app_theme.dart';

class TimezoneConverterScreen extends StatefulWidget {
  const TimezoneConverterScreen({super.key});

  @override
  State<TimezoneConverterScreen> createState() =>
      _TimezoneConverterScreenState();
}

class _TimezoneConverterScreenState extends State<TimezoneConverterScreen> {
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _timeCtrl = TextEditingController();
  tz.Location _from = tz.getLocation('UTC');
  tz.Location _to = tz.getLocation('America/New_York');

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  List<String> get _allZones {
    final list = tz.timeZoneDatabase.locations.keys.toList()..sort();
    return list;
  }

  List<String> get _popularZones => const [
        'UTC',
        'Europe/London',
        'Europe/Paris',
        'Europe/Berlin',
        'Europe/Madrid',
        'Europe/Rome',
        'Europe/Amsterdam',
        'Europe/Oslo',
        'Europe/Stockholm',
        'Europe/Moscow',
        'Asia/Tehran',
        'Asia/Dubai',
        'Asia/Karachi',
        'Asia/Kolkata',
        'Asia/Dhaka',
        'Asia/Bangkok',
        'Asia/Singapore',
        'Asia/Hong_Kong',
        'Asia/Tokyo',
        'Asia/Seoul',
        'Asia/Shanghai',
        'Asia/Jakarta',
        'America/New_York',
        'America/Chicago',
        'America/Denver',
        'America/Los_Angeles',
        'America/Toronto',
        'America/Sao_Paulo',
        'America/Mexico_City',
        'America/Bogota',
        'America/Lima',
        'Australia/Sydney',
        'Australia/Melbourne',
        'Australia/Perth',
        'Pacific/Auckland',
        'Africa/Cairo',
        'Africa/Nairobi',
        'Africa/Johannesburg',
      ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _selectedDate ?? now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = DateFormat.yMMMMd().format(picked);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
        _timeCtrl.text = DateFormat.Hm().format(dt);
      });
    }
  }

  tz.TZDateTime _composeDateTime(tz.Location loc) {
    final date = _selectedDate ?? DateTime.now();
    final time = _selectedTime ?? TimeOfDay.now();
    return tz.TZDateTime(
        loc, date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay.fromDateTime(now);
    _dateCtrl.text = DateFormat.yMMMMd().format(_selectedDate!);
    _timeCtrl.text = DateFormat.Hm()
        .format(DateTime(0, 1, 1, _selectedTime!.hour, _selectedTime!.minute));
  }

  @override
  Widget build(BuildContext context) {
    final input = _composeDateTime(_from);
    final converted = tz.TZDateTime.from(input, _to);
    final fmt = DateFormat.yMMMMd().add_Hm();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildControlsCard(context),
                      SizedBox(height: 2.h),
                      _buildResultCard(context, input, converted, fmt),
                    ],
                  ),
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
            'Timezone Converter',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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

  Future<void> _openTimezonePicker({required bool isFrom}) async {
    final controller = TextEditingController();
    final zones = _allZones;
    String? selected;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        List<String> filtered = zones;
        return StatefulBuilder(
          builder: (context, setModalState) {
            void filter(String q) {
              setModalState(() {
                filtered = zones
                    .where((z) => z.toLowerCase().contains(q.toLowerCase()))
                    .toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 4.w,
                right: 4.w,
                top: 2.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10.w,
                    height: 0.6.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  TextField(
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                    ),
                    controller: controller,
                    onChanged: filter,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Search timezone',
                      hintStyle: TextStyle(
                        color: AppTheme.getTextPrimaryColor(context),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  SizedBox(
                    height: 50.h,
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final z = filtered[index];
                        return ListTile(
                          title: Text(z,
                              style: TextStyle(
                                  color:
                                      AppTheme.getTextPrimaryColor(context))),
                          onTap: () {
                            selected = z;
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        if (isFrom) {
          _from = tz.getLocation(selected!);
        } else {
          _to = tz.getLocation(selected!);
        }
      });
    }
  }

  Widget _buildControlsCard(BuildContext context) {
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
              'From',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextPrimaryColor(context),
              ),
            ),
            SizedBox(height: 1.h),
            _ZoneDropdown(
                value: _from,
                zones: _popularZones,
                onChanged: (z) => setState(() => _from = tz.getLocation(z))),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _openTimezonePicker(isFrom: true),
                icon: const Icon(Icons.public),
                label: const Text('Browse all timezones'),
              ),
            ),
            SizedBox(height: 1.5.h),
            _buildDateTimePickers(),
            SizedBox(height: 1.5.h),
            Divider(color: Theme.of(context).dividerColor),
            SizedBox(height: 1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    final temp = _from;
                    _from = _to;
                    _to = temp;
                  }),
                  icon: const Icon(Icons.swap_vert),
                  label: const Text('Swap'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 1.5.h),
            Text(
              'To',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextPrimaryColor(context),
              ),
            ),
            SizedBox(height: 1.h),
            _ZoneDropdown(
                value: _to,
                zones: _popularZones,
                onChanged: (z) => setState(() => _to = tz.getLocation(z))),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _openTimezonePicker(isFrom: false),
                icon: const Icon(Icons.public),
                label: const Text('Browse all timezones'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, tz.TZDateTime input,
      tz.TZDateTime converted, DateFormat fmt) {
    String offsetString(tz.TZDateTime dt) {
      final duration = dt.timeZoneOffset; // Duration
      final totalMinutes = duration.inMinutes;
      final sign = totalMinutes >= 0 ? '+' : '-';
      final abs = totalMinutes.abs();
      final hours = (abs ~/ 60).toString().padLeft(2, '0');
      final mins = (abs % 60).toString().padLeft(2, '0');
      return 'UTC$sign$hours:$mins';
    }

    Widget chip(String text) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
        decoration: BoxDecoration(
          color: AppTheme.getPrimaryColor(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppTheme.getPrimaryColor(context),
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
        ),
      );
    }

    Future<void> copy(String text) async {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      }
    }

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
                  child: Icon(Icons.access_time,
                      color: AppTheme.getPrimaryColor(context)),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Result',
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fmt.format(input),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.getTextPrimaryColor(context),
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: [
                          chip(_from.name),
                          chip(offsetString(input)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => copy(fmt.format(input)),
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy',
                ),
              ],
            ),
            SizedBox(height: 1.2.h),
            Divider(color: Theme.of(context).dividerColor),
            SizedBox(height: 1.2.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fmt.format(converted),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.getTextPrimaryColor(context),
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: [
                          chip(_to.name),
                          chip(offsetString(converted)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => copy(fmt.format(converted)),
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      children: [
        TextField(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          controller: _dateCtrl,
          readOnly: true,
          style: TextStyle(color: AppTheme.getTextPrimaryColor(context)),
          decoration: const InputDecoration(labelText: 'Date'),
          onTap: _pickDate,
        ),
        SizedBox(height: 1.5.h),
        TextField(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          controller: _timeCtrl,
          readOnly: true,
          style: TextStyle(color: AppTheme.getTextPrimaryColor(context)),
          decoration: const InputDecoration(labelText: 'Time'),
          onTap: _pickTime,
        ),
      ],
    );
  }
}

class _ZoneDropdown extends StatelessWidget {
  final tz.Location value;
  final List<String> zones;
  final void Function(String) onChanged;

  const _ZoneDropdown({
    required this.value,
    required this.zones,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value.name,
      items: zones
          .map((z) => DropdownMenuItem(
              value: z,
              child: Text(
                z,
                style: TextStyle(color: AppTheme.getTextPrimaryColor(context)),
              )))
          .toList(),
      onChanged: (z) {
        if (z != null) onChanged(z);
      },
      decoration: InputDecoration(
        labelText: 'Timezone',
        labelStyle: TextStyle(color: AppTheme.getTextPrimaryColor(context)),
      ),
    );
  }
}
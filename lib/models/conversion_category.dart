import 'dart:ui_web';

import 'package:daliconverter/models/conversion_unit.dart';


class ConversionCategory {

final String name; 
final String icon;

final   List<ConversionUnit> units;


const ConversionCategory({
  required this.name,
required this.icon,
required this.units
});


@override
String toString()=> name;

 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionCategory &&
          runtimeType == other.runtimeType &&
          name == other.name;

@override

int get hashcode=name.hashcode;

}


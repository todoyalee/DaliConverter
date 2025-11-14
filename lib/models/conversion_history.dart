class ConversionHistory {

  final String categoryName;

  final String fromUnit;

  final String toUnit;
  final double inputValue;

  final double resultValue;

  final DateTime timestamp;



const ConversionHistory({
  required this.categoryName,
  required this.fromUnit,
  required this.inputValue,
  required this.resultValue,
  required this.timestamp,
  required this.toUnit

});



Map<String,dynamic> toJson(){
  return {
    'categoryName':categoryName,
    'fromUnit':fromUnit,
    'inputValue':inputValue,
    'resultValue':resultValue,
          'timestamp': timestamp.millisecondsSinceEpoch,
    'tounit':toUnit,


  };
}


factory ConversionHistory.fromJson(Map<String,dynamic>json){
  return ConversionHistory(categoryName: json['categoryName'], 
  fromUnit: json['fromUnit'], inputValue: json['inputValue'],
   resultValue: json['resultValue'], timestamp: json['timestamp'], 
   toUnit: json['toUnit']) ;
}


String  get formattedResult {
  String  formattedInput= inputValue==inputValue.toInt()
  ? inputValue.toInt().toString()
  :inputValue.toStringAsFixed(2);


  String formattedOutput = resultValue==resultValue.toInt()
  ? resultValue.toInt().toString()
  : resultValue.toStringAsFixed(4);

  return '$formattedInput $fromUnit = $formattedOutput $toUnit';
}

}




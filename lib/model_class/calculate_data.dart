CalculateData calculateData (json) => CalculateData.fromJson(json);

class CalculateData {
  final Map<String, double> data;

  CalculateData({required this.data});

  factory CalculateData.fromJson(Map<String, dynamic> json) {
    Map<String, double> parsedData = {};
    json.forEach((key, value) {
      parsedData[key] = value.toDouble();
    });
    return CalculateData(data: parsedData);
  }

  double? getValue(String hour) {
    return data[hour];
  }
}
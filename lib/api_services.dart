import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'model_class/calculate_data.dart';
import 'model_class/count_data.dart';
import 'model_class/register_data.dart';


final dio = Dio();


class Failure {
  late Object errorMessage;

  Failure({
    required this.errorMessage,
  });

  Failure.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'][0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorMessage'] = errorMessage;

    return data;
  }
}

class ApiHelper{
  static const _baseUrl = "http://54.234.163.158:5000/";
  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson;
      case 400:
        throw Failure(errorMessage : response.statusMessage.toString());
      case 422:
       throw Failure(errorMessage : response.statusMessage.toString());
      case 403:
        throw Failure(errorMessage : response.statusMessage.toString());
      case 500:
      default:
        throw Failure(errorMessage :
        'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> get(String url) async {
    var apiUrl = _baseUrl + url;
    dynamic responseJson;
    try {
      final response = await dio.get(apiUrl);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw Failure(errorMessage :'No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    var apiUrl = _baseUrl + url ;
    dynamic responseJson;
    try {
      final response = await dio.post(
          apiUrl,
        data: jsonEncode(body),
        options: Options(
      headers: {'Content-Type': 'application/json'},
      ),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw Failure(errorMessage :'No Internet connection');
    }

    return responseJson;
  }

}

class ApiServices{
  final  _helper = ApiHelper();
  Future<GetCount> getNewsData(String date) async {
    final response = await _helper.get('get_visit_count/?date=$date');
    return getCountData(response);
  }

  Future <RegisterVisitResponse> register(Map<String, dynamic> body) async{
    final response = await _helper.post('register_visit/', body);
  return registerVisitResponse(response);
  }

  Future <CalculateData> getListOfCrowd(Map<String, dynamic> body) async{
    final response = await _helper.post('calculate/', body);
  return calculateData(response);
  }
}
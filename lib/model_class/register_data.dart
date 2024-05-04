RegisterVisitResponse registerVisitResponse (json) => RegisterVisitResponse.fromJson(json);

class RegisterVisitResponse {
  final String message;

  RegisterVisitResponse({required this.message});

  factory RegisterVisitResponse.fromJson(Map<String, dynamic> json) {
    return RegisterVisitResponse(
      message: json['message'],
    );
  }
}
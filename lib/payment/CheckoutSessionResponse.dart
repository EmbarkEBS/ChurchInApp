// ignore_for_file: file_names

class CheckoutSessionResponse {
  late int session;

  CheckoutSessionResponse(Map<String, dynamic> sessionMap) {
    session = sessionMap['session']; // Accessing 'session' key from the map
  }
}

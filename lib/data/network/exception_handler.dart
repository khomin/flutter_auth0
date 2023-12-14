part of auth0;

Future<Response> handleError(DioException error, JsonDecoder _decoder) {
  if (error.error is SocketException)
    throw error.error ?? Object();
  else if (error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.connectionTimeout) {
    throw SocketException(error.toString());
  } else {
    if (error.response != null) {
      if (error.response?.statusCode == 401) {
        throw AuthException(name: 'unauthorized');
      }
      var err = error.response?.data["error"] ?? error.response?.data['name'];
      var desc = error.response?.data["error_description"] ??
          error.response?.data["message"] ??
          error.response?.data["description"];
      var optional = error.response?.data?['mfa_token'] ?? null;
      throw AuthException(name: err, description: desc, optional: optional);
    } else
      throw AuthException(description: error.error.toString());
  }
}

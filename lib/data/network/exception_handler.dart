part of auth0;

void handleError(DioError error, JsonDecoder _decoder) {
  if (error.error is SocketException)
    throw error.error!;
  else if (error.type == DioErrorType.receiveTimeout ||
      error.type == DioErrorType.sendTimeout ||
      error.type == DioErrorType.connectionTimeout) {
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

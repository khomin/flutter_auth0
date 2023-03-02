part of auth0;

/// Class that presents general exception from auth0
class AuthException implements Exception {
  final String? name;
  final String? description;
  final String? optional;

  AuthException(
      {this.name = 'a0.response.invalid',
      this.description = 'unknown error',
      this.optional});

  @override
  String toString() {
    return "$name $description";
  }
}

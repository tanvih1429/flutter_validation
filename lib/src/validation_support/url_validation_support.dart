/// Chainable validation rules for URL values.
class UrlValidationSupport {
  final String _value;
  String? _error;

  /// Creates a URL validator for the provided value.
  UrlValidationSupport(this._value);

  /// Returns the first validation error, or `null` if all rules passed.
  String? validate() => _error;

  /// Fails when the URL is empty or contains only whitespace.
  UrlValidationSupport required({String? message}) {
    if (_error != null) return this;

    if (_value.trim().isEmpty) {
      _error = message ?? "URL is required";
    }
    return this;
  }

  /// Fails when the value is not a parseable absolute URL.
  UrlValidationSupport validUrl({String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      _error = message ?? "Invalid URL";
    }

    return this;
  }

  /// Fails when the scheme is not `http` or `https`.
  UrlValidationSupport httpOrHttps({String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null || !(uri.scheme == "http" || uri.scheme == "https")) {
      _error = message ?? "Only HTTP/HTTPS URLs allowed";
    }

    return this;
  }

  /// Fails when the scheme is not `https`.
  UrlValidationSupport httpsOnly({String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null || uri.scheme != "https") {
      _error = message ?? "Only HTTPS URLs allowed";
    }

    return this;
  }

  /// Fails when the parsed URL does not contain a basic valid domain.
  UrlValidationSupport validDomain({String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null || uri.host.isEmpty || !uri.host.contains(".")) {
      _error = message ?? "Invalid domain";
    }

    return this;
  }

  /// Fails when an IP-host URL is present and [allow] is `false`.
  UrlValidationSupport allowIp({bool allow = true, String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null) {
      _error = message ?? "Invalid URL";
      return this;
    }

    final isIp = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$').hasMatch(uri.host);

    if (!allow && isIp) {
      _error = message ?? "IP addresses are not allowed";
    }

    return this;
  }

  /// Fails when the URL host is not one of the allowed [domains].
  UrlValidationSupport allowedDomains(List<String> domains, {String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null || !domains.contains(uri.host)) {
      _error = message ?? "Domain not allowed";
    }

    return this;
  }

  /// Fails when the URL host matches one of the blocked [domains].
  UrlValidationSupport blockedDomains(List<String> domains, {String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri != null && domains.contains(uri.host)) {
      _error = message ?? "Domain is blocked";
    }

    return this;
  }

  /// Fails when query parameters are present while [allow] is `false`.
  UrlValidationSupport allowQueryParams(bool allow, {String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null) {
      _error = message ?? "Invalid URL";
      return this;
    }

    if (!allow && uri.hasQuery) {
      _error = message ?? "Query parameters not allowed";
    }

    return this;
  }

  /// Fails when fragments are present while [allow] is `false`.
  UrlValidationSupport allowFragments(bool allow, {String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null) {
      _error = message ?? "Invalid URL";
      return this;
    }

    if (!allow && uri.fragment.isNotEmpty) {
      _error = message ?? "Fragments not allowed";
    }

    return this;
  }

  /// Fails when the URL path does not contain [path].
  UrlValidationSupport containsPath(String path, {String? message}) {
    if (_error != null) return this;

    final uri = Uri.tryParse(_value);

    if (uri == null || !uri.path.contains(path)) {
      _error = message ?? "URL must contain '$path'";
    }

    return this;
  }

  /// Fails when the URL is shorter than [length].
  UrlValidationSupport minLength(int length, {String? message}) {
    if (_error != null) return this;

    if (_value.length < length) {
      _error = message ?? "URL too short";
    }

    return this;
  }

  /// Fails when the URL is longer than [length].
  UrlValidationSupport maxLength(int length, {String? message}) {
    if (_error != null) return this;

    if (_value.length > length) {
      _error = message ?? "URL too long";
    }

    return this;
  }

  /// Applies a custom [validate] function and stores [message] when it fails.
  UrlValidationSupport custom(
    bool Function(String value) validate, {
    String? message,
  }) {
    if (_error != null) return this;

    if (!validate(_value)) {
      _error = message ?? "Invalid URL";
    }

    return this;
  }
}

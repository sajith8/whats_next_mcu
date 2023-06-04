interface class MovieException{
  const MovieException(this.message);
  final String message;
}

final class MovieFetchException implements MovieException{
  const MovieFetchException(this.message);

  @override
  final String message;
}

final class MovieUnknownException implements MovieException{
  const MovieUnknownException(this.message);

  @override
  final String message;
}

final class MovieConnectivityException implements MovieException{
  const MovieConnectivityException(this.message);

  @override
  final String message;
}


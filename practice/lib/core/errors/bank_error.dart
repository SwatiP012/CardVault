enum BankErrorCode {
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  network,
  server,
  unknown,
}

class BankError implements Exception {
  final BankErrorCode code;
  final String message;

  const BankError({required this.code, required this.message});

  @override
  String toString() {
    return 'BankError(${code.name}): $message';
  }
}

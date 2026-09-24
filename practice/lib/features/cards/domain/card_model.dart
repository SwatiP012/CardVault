enum CardType { debit, credit }

enum CardStatus { active, frozen, blocked }

class CardModel {
  final String id;
  final CardType type;
  final String network;
  final String maskedNumber;
  final String expiry;
  final CardStatus status;

  const CardModel({
    required this.id,
    required this.type,
    required this.network,
    required this.maskedNumber,
    required this.expiry,
    required this.status,
  });

  CardModel copyWith({
    String? id,
    CardType? type,
    String? network,
    String? maskedNumber,
    String? expiry,
    CardStatus? status,
  }) {
    return CardModel(
      id: id ?? this.id,
      type: type ?? this.type,
      network: network ?? this.network,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      expiry: expiry ?? this.expiry,
      status: status ?? this.status,
    );
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      type: json['type'] == 'CREDIT' ? CardType.credit : CardType.debit,
      network: json['network'] as String,
      maskedNumber: json['maskedNumber'] as String,
      expiry: json['expiry'] as String,
      status: _statusFromString(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type == CardType.credit ? 'CREDIT' : 'DEBIT',
      'network': network,
      'maskedNumber': maskedNumber,
      'expiry': expiry,
      'status': status.name.toUpperCase(),
    };
  }

  static CardStatus _statusFromString(String status) {
    switch (status) {
      case 'FROZEN':
        return CardStatus.frozen;
      case 'BLOCKED':
        return CardStatus.blocked;
      default:
        return CardStatus.active;
    }
  }
}

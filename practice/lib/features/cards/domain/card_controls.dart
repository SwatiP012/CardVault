class CardControls {
  final bool online;
  final bool contactless;
  final bool atm;
  final bool international;
  final DateTime? internationalUntil;

  const CardControls({
    required this.online,
    required this.contactless,
    required this.atm,
    required this.international,
    this.internationalUntil,
  });

  CardControls copyWith({
    bool? online,
    bool? contactless,
    bool? atm,
    bool? international,
    DateTime? internationalUntil,
  }) {
    return CardControls(
      online: online ?? this.online,
      contactless: contactless ?? this.contactless,
      atm: atm ?? this.atm,
      international: international ?? this.international,
      internationalUntil: internationalUntil ?? this.internationalUntil,
    );
  }

  factory CardControls.fromJson(Map<String, dynamic> json) {
    return CardControls(
      online: json['online'] as bool,
      contactless: json['contactless'] as bool,
      atm: json['atm'] as bool,
      international: json['international'] as bool,
      internationalUntil: json['internationalUntil'] != null
          ? DateTime.parse(json['internationalUntil'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'online': online,
      'contactless': contactless,
      'atm': atm,
      'international': international,
      'internationalUntil': internationalUntil?.toUtc().toIso8601String(),
    };
  }
}

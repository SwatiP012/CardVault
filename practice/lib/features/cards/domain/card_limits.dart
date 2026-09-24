class CardLimits {
  final int atmDailyPaise;
  final int posDailyPaise;
  final int onlineDailyPaise;
  final int maxPaise;

  const CardLimits({
    required this.atmDailyPaise,
    required this.posDailyPaise,
    required this.onlineDailyPaise,
    required this.maxPaise,
  });

  CardLimits copyWith({
    int? atmDailyPaise,
    int? posDailyPaise,
    int? onlineDailyPaise,
    int? maxPaise,
  }) {
    return CardLimits(
      atmDailyPaise: atmDailyPaise ?? this.atmDailyPaise,
      posDailyPaise: posDailyPaise ?? this.posDailyPaise,
      onlineDailyPaise: onlineDailyPaise ?? this.onlineDailyPaise,
      maxPaise: maxPaise ?? this.maxPaise,
    );
  }

  factory CardLimits.fromJson(Map<String, dynamic> json) {
    return CardLimits(
      atmDailyPaise: json['atmDailyPaise'] as int,
      posDailyPaise: json['posDailyPaise'] as int,
      onlineDailyPaise: json['onlineDailyPaise'] as int,
      maxPaise: json['maxPaise'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atmDailyPaise': atmDailyPaise,
      'posDailyPaise': posDailyPaise,
      'onlineDailyPaise': onlineDailyPaise,
      'maxPaise': maxPaise,
    };
  }
}

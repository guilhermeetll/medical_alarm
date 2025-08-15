class InfusionPumpData {
  final String pumpSerialNumber;
  final int cod;
  final String state;
  final String message;
  final String updatedAt;

  InfusionPumpData({
    required this.pumpSerialNumber,
    required this.cod,
    required this.state,
    required this.message,
    required this.updatedAt,
  });

  factory InfusionPumpData.fromJson(Map<String, dynamic> json) {
    return InfusionPumpData(
      pumpSerialNumber: json['pumpSerialNumber'] ?? '',
      cod: json['cod'] ?? -1,
      state: json['state'] ?? '',
      message: json['message'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

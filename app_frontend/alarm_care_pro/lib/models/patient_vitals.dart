import 'package:alarm_care_pro/models/ventilator_data.dart';

class PatientVitals {
  final String type;
  final List<Variable> variables;
  final List<Alarm> alarms;

  PatientVitals({
    required this.type,
    required this.variables,
    required this.alarms,
  });

  factory PatientVitals.fromJson(Map<String, dynamic> json) {
    return PatientVitals(
      type: json['type'] ?? '',
      variables: (json['variables'] as List<dynamic>?)
              ?.map((e) => Variable.fromJson(e))
              .toList() ??
          [],
      alarms: (json['alarms'] as List<dynamic>?)
              ?.map((e) => Alarm.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class VentilatorData {
  final String type;
  final List<Variable> variables;
  final List<Alarm> alarms;

  VentilatorData({
    required this.type,
    required this.variables,
    required this.alarms,
  });

  factory VentilatorData.fromJson(Map<String, dynamic> json) {
    return VentilatorData(
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

class Variable {
  final String name;
  final String value;
  final String unit;

  Variable({
    required this.name,
    required this.value,
    required this.unit,
  });

  factory Variable.fromJson(Map<String, dynamic> json) {
    return Variable(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      unit: json['unit'] ?? '',
    );
  }
}

class Alarm {
  final String id;
  final String state;
  final String priority;

  Alarm({
    required this.id,
    required this.state,
    required this.priority,
  });

  int get priorityLevel {
    switch (priority) {
      case 'HI':
        return 2;
      case 'MED':
        return 1;
      case 'LOW':
        return 0;
      default:
        return -1;
    }
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] ?? '',
      state: json['state'] ?? '',
      priority: json['priority'] ?? '',
    );
  }
}

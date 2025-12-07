class CalculationModel {
  final int? id;
  final String mass;
  final String radius;
  final double velocityMs;
  final double velocityKmS;
  final DateTime createdAt;

  CalculationModel({
    this.id,
    required this.mass,
    required this.radius,
    required this.velocityMs,
    required this.velocityKmS,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mass': mass,
      'radius': radius,
      'velocity_ms': velocityMs,
      'velocity_kms': velocityKmS,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CalculationModel.fromMap(Map<String, dynamic> map) {
    return CalculationModel(
      id: map['id'],
      mass: map['mass'],
      radius: map['radius'],
      velocityMs: map['velocity_ms'],
      velocityKmS: map['velocity_kms'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  @override
  String toString() {
    return 'CalculationModel{id: $id, mass: $mass, radius: $radius, velocityMs: $velocityMs, velocityKmS: $velocityKmS, createdAt: $createdAt}';
  }
}
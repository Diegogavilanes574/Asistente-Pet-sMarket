import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/model/question.dart';

class Answer extends Equatable {
  final Symptom symptom;
  final int value;

  const Answer({
    required this.symptom,
    required this.value,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{symptom.nombre: value};

  @override
  List<Object?> get props => [symptom, value];
}

class Prediction extends Equatable {
  final String resultado;
  final double confianza;
  final List<Treatment> tratamientos;

  const Prediction({
    required this.resultado,
    required this.confianza,
    required this.tratamientos,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      resultado: json['resultado'] as String,
      confianza: json['confianza'] as double,
      tratamientos: (json['tratamientos'] as List)
          .map((e) => Treatment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [resultado, confianza];
}

class Treatment extends Equatable {
  final String tratamiento;

  const Treatment({
    required this.tratamiento,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      tratamiento: json['tratamiento'] as String,
    );
  }

  @override
  List<Object?> get props => [tratamiento,];
}
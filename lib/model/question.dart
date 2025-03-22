import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question extends Equatable {
  final int id;
  final String text;
  final List<Options> options;
  final int estado;
  final Symptom symptom;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.estado,
    required this.symptom,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  @override
  List<Object?> get props => [id, text, options, estado, symptom];
}

@JsonSerializable()
class Options extends Equatable {
  final int id;
  final String text;
  final int estado;
  @JsonKey(name: 'estado_validacion')
  final int estadoValidacion;

  const Options({
    required this.id,
    required this.text,
    required this.estado,
    required this.estadoValidacion,
  });

  factory Options.fromJson(Map<String, dynamic> json) => _$OptionsFromJson(json);

  @override
  List<Object?> get props => [id, text, estado, estadoValidacion];
}

@JsonSerializable()
class Symptom extends Equatable {
  final int id;
  final String nombre;
  final int estado;

  const Symptom({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) => _$SymptomFromJson(json);

  @override
  List<Object?> get props => [id, nombre, estado];
}

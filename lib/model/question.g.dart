// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => Options.fromJson(e as Map<String, dynamic>))
          .toList(),
      estado: (json['estado'] as num).toInt(),
      symptom: Symptom.fromJson(json['symptom'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'options': instance.options,
      'estado': instance.estado,
      'symptom': instance.symptom,
    };

Options _$OptionsFromJson(Map<String, dynamic> json) => Options(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      estado: (json['estado'] as num).toInt(),
      estadoValidacion: (json['estado_validacion'] as num).toInt(),
    );

Map<String, dynamic> _$OptionsToJson(Options instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'estado': instance.estado,
      'estado_validacion': instance.estadoValidacion,
    };

Symptom _$SymptomFromJson(Map<String, dynamic> json) => Symptom(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      estado: (json['estado'] as num).toInt(),
    );

Map<String, dynamic> _$SymptomToJson(Symptom instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'estado': instance.estado,
    };

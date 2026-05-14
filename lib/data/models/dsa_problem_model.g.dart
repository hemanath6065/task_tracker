// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dsa_problem_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DsaProblemModelAdapter extends TypeAdapter<DsaProblemModel> {
  @override
  final int typeId = 4;

  @override
  DsaProblemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DsaProblemModel(
      id: fields[0] as String,
      name: fields[1] as String,
      topic: fields[2] as String,
      isSolved: fields[3] as bool,
      solvedAt: fields[4] as DateTime?,
      difficulty: fields[5] as String,
      revisionCount: fields[6] as int,
      notes: fields[7] as String?,
      lastRevisionDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DsaProblemModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.topic)
      ..writeByte(3)
      ..write(obj.isSolved)
      ..writeByte(4)
      ..write(obj.solvedAt)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.revisionCount)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.lastRevisionDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DsaProblemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

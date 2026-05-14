// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopicModelAdapter extends TypeAdapter<TopicModel> {
  @override
  final int typeId = 1;

  @override
  TopicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopicModel(
      id: fields[0] as String,
      name: fields[1] as String,
      phase: fields[2] as int,
      parentTopic: fields[3] as String,
      isCompleted: fields[4] as bool,
      completedAt: fields[5] as DateTime?,
      difficulty: fields[6] as String,
      revisionCount: fields[7] as int,
      lastRevisionDate: fields[8] as DateTime?,
      nextRevisionDate: fields[9] as DateTime?,
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TopicModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phase)
      ..writeByte(3)
      ..write(obj.parentTopic)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.completedAt)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.revisionCount)
      ..writeByte(8)
      ..write(obj.lastRevisionDate)
      ..writeByte(9)
      ..write(obj.nextRevisionDate)
      ..writeByte(10)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

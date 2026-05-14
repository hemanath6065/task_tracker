// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyLogModelAdapter extends TypeAdapter<DailyLogModel> {
  @override
  final int typeId = 2;

  @override
  DailyLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyLogModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      studyMinutes: fields[2] as int,
      tasksCompleted: fields[3] as int,
      totalTasks: fields[4] as int,
      mood: fields[5] as String?,
      reflection: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyLogModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.studyMinutes)
      ..writeByte(3)
      ..write(obj.tasksCompleted)
      ..writeByte(4)
      ..write(obj.totalTasks)
      ..writeByte(5)
      ..write(obj.mood)
      ..writeByte(6)
      ..write(obj.reflection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

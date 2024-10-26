// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 1;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job(
      id: fields[0] as int,
      title: fields[1] as String,
      weekDayRate: fields[2] as double,
      saturdayRate: fields[4] as double,
      sundayRate: fields[3] as double,
      breakHours: fields[5] as double,
      hoursTillBreak: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.weekDayRate)
      ..writeByte(3)
      ..write(obj.sundayRate)
      ..writeByte(4)
      ..write(obj.saturdayRate)
      ..writeByte(5)
      ..write(obj.breakHours)
      ..writeByte(6)
      ..write(obj.hoursTillBreak);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

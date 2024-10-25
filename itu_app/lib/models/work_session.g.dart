// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkSessionAdapter extends TypeAdapter<WorkSession> {
  @override
  final int typeId = 2;

  @override
  WorkSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkSession(
      id: fields[0] as int,
      jobId: fields[1] as int,
      date: fields[2] as DateTime,
      hoursWorked: fields[3] as double,
      extraPay: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WorkSession obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.hoursWorked)
      ..writeByte(4)
      ..write(obj.extraPay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

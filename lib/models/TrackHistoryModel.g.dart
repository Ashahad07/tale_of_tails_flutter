// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TrackHistoryModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackHistoryAdapter extends TypeAdapter<TrackHistory> {
  @override
  final int typeId = 1;

  @override
  TrackHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackHistory(
      startLatitude: fields[0] as double,
      startLongitude: fields[1] as double,
      endLatitude: fields[2] as double,
      endLongitude: fields[3] as double,
      startTime: fields[4] as String,
      endTime: fields[5] as String,
      totalDistance: fields[6] as double,
      totalTime: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrackHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.startLatitude)
      ..writeByte(1)
      ..write(obj.startLongitude)
      ..writeByte(2)
      ..write(obj.endLatitude)
      ..writeByte(3)
      ..write(obj.endLongitude)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.totalDistance)
      ..writeByte(7)
      ..write(obj.totalTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

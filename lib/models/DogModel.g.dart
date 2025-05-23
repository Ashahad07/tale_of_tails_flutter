// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DogModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DogModelAdapter extends TypeAdapter<DogModel> {
  @override
  final int typeId = 0;

  @override
  DogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DogModel(
      name: fields[0] as String,
      breed: fields[1] as String,
      image: fields[4] as String,
      breedGroup: fields[2] as String?,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DogModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.breed)
      ..writeByte(2)
      ..write(obj.breedGroup)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

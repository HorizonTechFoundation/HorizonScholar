// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cgpa_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CgpaModelAdapter extends TypeAdapter<CgpaModel> {
  @override
  final int typeId = 0;

  @override
  CgpaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CgpaModel(
      cgpa: fields[0] as double,
      currentSem: fields[1] as int,
      marks: (fields[2] as List)
          .map((dynamic e) => (e as List).cast<double>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, CgpaModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cgpa)
      ..writeByte(1)
      ..write(obj.currentSem)
      ..writeByte(2)
      ..write(obj.marks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CgpaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

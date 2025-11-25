// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectModelAdapter extends TypeAdapter<SubjectModel> {
  @override
  final int typeId = 4;

  @override
  SubjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectModel(
      semester: fields[0] as int,
      name: fields[1] as String,
      credits: fields[2] as double,
      grade: fields[3] as String,
      code: fields[4] == null ? 'None' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.semester)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.credits)
      ..writeByte(3)
      ..write(obj.grade)
      ..writeByte(4)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

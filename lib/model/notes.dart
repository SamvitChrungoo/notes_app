import 'package:hive/hive.dart';
part 'notes.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String createdAt;
  @HiveField(2)
  String updatedAt;
  @HiveField(3)
  String title;
  @HiveField(4)
  String content;

  Note(this.id, this.createdAt, this.updatedAt, this.title, this.content);
}

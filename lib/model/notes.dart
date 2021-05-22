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
  @HiveField(5)
  bool starred;

  Note(this.id, this.createdAt, this.updatedAt, this.title, this.content,
      this.starred);

  Note copyWith({
    String id,
    String createdAt,
    String updatedAt,
    String title,
    String content,
    bool starred,
  }) =>
      Note(
        id ?? this.id,
        createdAt ?? this.createdAt,
        updatedAt ?? this.updatedAt,
        title ?? this.title,
        content ?? this.content,
        starred ?? this.starred,
      );
}

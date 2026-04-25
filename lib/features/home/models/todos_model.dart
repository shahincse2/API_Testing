class AlbumsModel {
  int id;
  int userId;
  String title;
  bool completed;

  AlbumsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  factory AlbumsModel.fromJson(Map<String, dynamic> json) {
    return AlbumsModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

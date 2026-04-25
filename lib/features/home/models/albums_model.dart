class AlbumsModel {
  int id;
  int userId;
  String title;

  AlbumsModel({
    required this.id,
    required this.userId,
    required this.title,
});

  factory AlbumsModel.fromJson(Map<String, dynamic> json) {
    return AlbumsModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
    );
  }
}
class TodosModel {
  int id;
  int albumId;
  String title;
  String url;
  String thumbnailUrl;

  TodosModel({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
});
  factory TodosModel.fromJson(Map<String, dynamic> json) {
    return TodosModel(
      id: json['id'],
      albumId: json['albumId'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

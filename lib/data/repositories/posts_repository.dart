import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/features/home/models/post_model.dart';

class PostsRepository {
  final ApiService apiService;

  PostsRepository(this.apiService);

  Future<List<PostModel>> fetchPosts() async {
    final data = await apiService.get(
      'https://jsonplaceholder.typicode.com/posts',
    );

    return data.map((e) => PostModel.fromJson(e)).toList();
  }
}
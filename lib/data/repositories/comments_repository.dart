import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/features/home/models/comments_model.dart';

class CommentsRepository {
  final ApiService apiService;
  CommentsRepository(this.apiService);

  Future<List<CommentsModel>> fetchComments() async{
    final data = await apiService.get(
      'https://jsonplaceholder.typicode.com/comments');
    return data.map((e) => CommentsModel.fromJson(e)).toList();
  }
}
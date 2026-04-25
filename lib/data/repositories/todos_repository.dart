import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/features/home/models/todos_model.dart';

class TodosRepository {
  final ApiService apiService;

  TodosRepository(this.apiService);

  // এখানে int page প্যারামিটার যোগ করা হয়েছে
  Future<List<AlbumsModel>> fetchTodos(int page) async {
    // ডাইনামিক URL যেখানে প্রতি পেজে ২০টি করে ডাটা আসবে
    final String url = 'https://jsonplaceholder.typicode.com/todos?_page=$page&_limit=20';

    final data = await apiService.get(url);
    return data.map((e) => AlbumsModel.fromJson(e)).toList();
  }
}
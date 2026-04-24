import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/features/home/models/usermod/user_mod.dart';

class UsersRepository {
  final ApiService apiService;

  UsersRepository(this.apiService);

  Future<List<UserModel>> fetchUsers() async {
    final data = await apiService.get(
      'https://jsonplaceholder.typicode.com/users',
    );

    return data.map((e) => UserModel.fromJson(e)).toList();
  }
}
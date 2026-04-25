import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/features/home/models/albums_model.dart';

class AlbumsRepository {
  final ApiService apiService;

  AlbumsRepository(this.apiService);

  Future<List<AlbumsModel>> fetchAlbums(int page) async {
    final String url = 'https://jsonplaceholder.typicode.com/albums?_page=$page&_limit=20';

    final data = await apiService.get(url);
    return data.map((e) => AlbumsModel.fromJson(e)).toList();
  }
}

import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/features/home/models/photos_model.dart';
//
// class PhotosRepository {
//   final ApiService apiService;
//
//   PhotosRepository(this.apiService);
//
//   Future<List<PhotosModel>> fetchPhotos() async {
//     final data = await apiService.get('https://jsonplaceholder.typicode.com/photos',);
//     return data.map((e) => PhotosModel.fromJson(e)).toList();
//   }
// }

class PhotosRepository {
  final ApiService apiService;

  PhotosRepository(this.apiService);

  // এখানে int page প্যারামিটার যোগ করা হয়েছে
  Future<List<PhotosModel>> fetchPhotos(int page) async {
    // ডাইনামিক URL যেখানে প্রতি পেজে ২০টি করে ডাটা আসবে
    final String url = 'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=20';

    final data = await apiService.get(url);
    return data.map((e) => PhotosModel.fromJson(e)).toList();
  }
}
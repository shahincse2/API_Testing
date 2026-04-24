import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/data/repositories/photos_repository.dart';
import 'package:api_testing/features/home/models/photos_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  // প্রয়োজনীয় ভেরিয়েবল
  List<PhotosModel> displayedPhotos = []; // স্ক্রিনে প্রদর্শিত লিস্ট
  int currentPage = 1; // বর্তমান পেজ নম্বর
  bool isLoading = false; // লোডিং স্টেট ট্র্যাকিং
  bool hasMoreData = true; // আরও ডাটা আছে কি না তা চেক করার জন্য

  late final PhotosRepository repository;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // রিপোজিটরি ইনিশিয়ালাইজেশন
    repository = PhotosRepository(ApiService());

    // স্ক্রল লিসেনার যোগ করা
    _scrollController.addListener(_onScroll);

    // প্রথম পেজের ডাটা লোড করা
    fetchInitialPhotos();
  }

  // স্ক্রল ডিটেকশন ফাংশন
  void _onScroll() {
    double threshold = 300.0; // শেষ থেকে ৩০০ পিক্সেল বাকি থাকতেই লোড শুরু হবে
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - threshold &&
        !isLoading &&
        hasMoreData) {
      fetchMorePhotos();
    }
  }

  // প্রথম পেজের ডাটা নিয়ে আসার ফাংশন
  Future<void> fetchInitialPhotos() async {
    setState(() => isLoading = true);
    try {
      final List<PhotosModel> data = await repository.fetchPhotos(currentPage);
      setState(() {
        displayedPhotos = data;
        isLoading = false;
        if (data.isEmpty) hasMoreData = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Initial Fetch Error: $e");
    }
  }

  // পরবর্তী পেজগুলোর ডাটা নিয়ে আসার ফাংশন
  void fetchMorePhotos() {
    setState(() => isLoading = true);
    int nextPage = currentPage + 1;

    // ১ সেকেন্ড ডিলে দেওয়া হয়েছে যাতে লোডিং ইফেক্ট বোঝা যায় (অপশনাল)
    Future.delayed(const Duration(seconds: 1), () async {
      try {
        final List<PhotosModel> newData = await repository.fetchPhotos(nextPage);

        setState(() {
          isLoading = false;
          if (newData.isNotEmpty) {
            currentPage = nextPage;
            displayedPhotos.addAll(newData); // নতুন ডাটা লিস্টে যোগ করা
          } else {
            hasMoreData = false; // আর কোনো ডাটা নেই
          }
        });
      } catch (e) {
        setState(() => isLoading = false);
        debugPrint("Load More Error: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Pagination Test"),
        centerTitle: true,
      ),
      body: displayedPhotos.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: displayedPhotos.length + (hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < displayedPhotos.length) {
            final photo = displayedPhotos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(photo.id.toString(), style: const TextStyle(fontSize: 10)),
                ),
                title: Text(
                  photo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/id/${photo.id}/400/200",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              ),
            );
          } else {
            // নিচে লোডিং ইন্ডিকেটর বা শেষ বার্তার জন্য
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: hasMoreData
                    ? const CircularProgressIndicator()
                    : const Text("No more data available"),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // মেমোরি লিক রোধ করতে ডিসপোজ করা
    super.dispose();
  }
}
import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/data/repositories/albums_repository.dart';
import 'package:api_testing/features/home/models/albums_model.dart';
import 'package:flutter/material.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  // প্রয়োজনীয় ভেরিয়েবল
  List<AlbumsModel> displayedAlbums = []; // স্ক্রিনে প্রদর্শিত লিস্ট
  int currentPage = 1; // বর্তমান পেজ নম্বর
  bool isLoading = false; // লোডিং স্টেট ট্র্যাকিং
  bool hasMoreData = true; // আরও ডাটা আছে কি না তা চেক করার জন্য

  late final AlbumsRepository repository;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // রিপোজিটরি ইনিশিয়ালাইজেশন
    repository = AlbumsRepository(ApiService());

    // স্ক্রল লিসেনার যোগ করা
    _scrollController.addListener(_onScroll);

    // প্রথম পেজের ডাটা লোড করা
    fetchInitialTodos();
  }

  // স্ক্রল ডিটেকশন ফাংশন
  void _onScroll() {
    double threshold = 300.0; // শেষ থেকে ৩০০ পিক্সেল বাকি থাকতেই লোড শুরু হবে
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - threshold &&
        !isLoading &&
        hasMoreData) {
      fetchMoreTodos();
    }
  }

  // প্রথম পেজের ডাটা নিয়ে আসার ফাংশন
  Future<void> fetchInitialTodos() async {
    setState(() => isLoading = true);
    try {
      final List<AlbumsModel> data = await repository.fetchAlbums(currentPage);
      setState(() {
        displayedAlbums = data;
        isLoading = false;
        if (data.isEmpty) hasMoreData = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Initial Fetch Error: $e");
    }
  }

  // পরবর্তী পেজগুলোর ডাটা নিয়ে আসার ফাংশন
  void fetchMoreTodos() {
    setState(() => isLoading = true);
    int nextPage = currentPage + 1;

    // ১ সেকেন্ড ডিলে দেওয়া হয়েছে যাতে লোডিং ইফেক্ট বোঝা যায় (অপশনাল)
    Future.delayed(const Duration(seconds: 1), () async {
      try {
        final List<AlbumsModel> newData = await repository.fetchAlbums(nextPage);

        setState(() {
          isLoading = false;
          if (newData.isNotEmpty) {
            currentPage = nextPage;
            displayedAlbums.addAll(newData); // নতুন ডাটা লিস্টে যোগ করা
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
      body: displayedAlbums.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: displayedAlbums.length + (hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < displayedAlbums.length) {
            final album = displayedAlbums[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(album.id.toString(), style: const TextStyle(fontSize: 10)),
                ),

                // bool ভ্যালু চেক করে আইকন বা টেক্সট দেখানো
                title: Text(
                  album.title,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
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
                    : const Text("No more data available..."),
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
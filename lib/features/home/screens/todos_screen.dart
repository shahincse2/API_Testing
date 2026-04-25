import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/data/repositories/todos_repository.dart';
import 'package:flutter/material.dart';
import 'package:api_testing/features/home/models/todos_model.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  // প্রয়োজনীয় ভেরিয়েবল
  List<AlbumsModel> displayedTodos = []; // স্ক্রিনে প্রদর্শিত লিস্ট
  int currentPage = 1; // বর্তমান পেজ নম্বর
  bool isLoading = false; // লোডিং স্টেট ট্র্যাকিং
  bool hasMoreData = true; // আরও ডাটা আছে কি না তা চেক করার জন্য

  late final TodosRepository repository;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // রিপোজিটরি ইনিশিয়ালাইজেশন
    repository = TodosRepository(ApiService());

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
      final List<AlbumsModel> data = await repository.fetchTodos(currentPage);
      setState(() {
        displayedTodos = data;
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
        final List<AlbumsModel> newData = await repository.fetchTodos(nextPage);

        setState(() {
          isLoading = false;
          if (newData.isNotEmpty) {
            currentPage = nextPage;
            displayedTodos.addAll(newData); // নতুন ডাটা লিস্টে যোগ করা
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
      body: displayedTodos.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: displayedTodos.length + (hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < displayedTodos.length) {
            final todos = displayedTodos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(todos.id.toString(), style: const TextStyle(fontSize: 10)),
                ),
                title: Text(
                  todos.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // bool ভ্যালু চেক করে আইকন বা টেক্সট দেখানো
                subtitle: Text(
                  todos.completed ? "Completed" : "Pending",
                  style: TextStyle(
                    color: todos.completed ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  todos.completed ? Icons.check_circle : Icons.pending,
                  color: todos.completed ? Colors.green : Colors.red,
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
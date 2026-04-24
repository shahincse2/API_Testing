import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/data/repositories/comments_repository.dart';
import 'package:api_testing/features/home/models/comments_model.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<CommentsModel> comments = [];

  late final CommentsRepository repository;

  @override
  void initState() {
    super.initState();
    repository = CommentsRepository(ApiService());
    fetchComments();
  }

  Future<void> fetchComments() async {
    final data = await repository.fetchComments();

    setState(() {
      comments = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: comments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Card(
                  elevation: 4,
                  shadowColor: Colors.black,
                  child: ListTile(
                    leading: CircleAvatar(
                      // child: Text(initials),
                      child: Text(comment.id.toString()),
                    ),
                    title: Text('Name: ${comment.name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${comment.email}'),
                        const SizedBox(height: 4),
                        Text('Body: ${comment.body}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

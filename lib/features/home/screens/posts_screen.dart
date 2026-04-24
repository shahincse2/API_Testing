import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/features/home/models/post_model.dart';
import 'package:api_testing/data/repositories/posts_repository.dart';
import 'package:flutter/material.dart';


class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<PostModel> posts = [];

  late final PostsRepository repository;

  @override
  void initState() {
    super.initState();
    repository = PostsRepository(ApiService());
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final data = await repository.fetchPosts();

    setState(() {
      posts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {

                // String name = user['name'];
                // List parts = name.split(' ');
                //
                // String initials = parts.length > 1
                //     ? parts[0][0] + parts[1][0]
                //     : parts[0][0];
                // initials = initials.toUpperCase();

                final post = posts[index];

                return Card(
                  elevation: 4,
                  shadowColor: Colors.black,
                  child: ListTile(
                    leading: CircleAvatar(
                      // child: Text(initials),
                      child: Text(
                        post.id.toString(),
                      ),
                    ),
                    title: Text('Title: ${post.title}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Body: ${post.body}')
                      ]
                    ),
                  ),
                );
              },
            ),
    );
  }
}

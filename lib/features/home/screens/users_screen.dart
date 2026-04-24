import 'package:api_testing/core/network/api_service.dart';
import 'package:api_testing/data/repositories/user_repository.dart';
import 'package:api_testing/features/home/models/usermod/user_mod.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserModel> users = [];
  late final UsersRepository repository;

  @override
  void initState() {
    super.initState();
    repository = UsersRepository(ApiService());
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final data = await repository.fetchUsers();

    setState(() {
      users = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                // String name = user['name'];
                // List parts = name.split(' ');
                //
                // String initials = parts.length > 1
                //     ? parts[0][0] + parts[1][0]
                //     : parts[0][0];
                // initials = initials.toUpperCase();

                return Card(
                  elevation: 4,
                  shadowColor: Colors.black,
                  child: ListTile(
                    leading: CircleAvatar(
                      // child: Text(initials),
                      child: Text(
                        user.name.split(' ').map((e) => e[0]).take(2).join(),
                      ),
                    ),
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username: ${user.username}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Email: ${user.email}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Phone: ${user.phone}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'Website: ${user.website}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

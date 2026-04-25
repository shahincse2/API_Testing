import 'package:api_testing/core/constant/app_icons.dart';
import 'package:api_testing/core/constant/app_strings.dart';
import 'package:api_testing/features/home/models/tab_item.dart';
import 'package:api_testing/features/home/screens/albums_screen.dart';
import 'package:api_testing/features/home/screens/comments_screen.dart';
import 'package:api_testing/features/home/screens/photos_screen.dart';
import 'package:api_testing/features/home/screens/posts_screen.dart';
import 'package:api_testing/features/home/screens/todos_screen.dart';
import 'package:api_testing/features/home/screens/users_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/build_tab_bar.dart';

class TabBarScreen extends StatelessWidget {
  const TabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TabItem> tabs = [
      TabItem(icon: AppIcons.people, label: AppStrings.people),
      TabItem(icon: AppIcons.posts, label: AppStrings.posts),
      TabItem(icon: AppIcons.comments, label: AppStrings.comments),
      TabItem(icon: AppIcons.photos, label: AppStrings.photos),
      TabItem(icon: AppIcons.albums, label: AppStrings.albums),
      TabItem(icon: AppIcons.todos, label: AppStrings.todos),
    ];

    final List<Widget> screens = [
      UsersScreen(),
      PostsScreen(),
      CommentsScreen(),
      PhotosScreen(),
      AlbumsScreen(),
      TodosScreen(),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          centerTitle: true,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: BuildTabBar(tabs: tabs),
          ),
        ),

        body: TabBarView(
          children: screens,
          // children: tabs.map((tab) {
          //   return Container(
          //     height: double.infinity,
          //     width: double.infinity,
          //     color: Colors.deepPurple,
          //     child: Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(tab.icon, size: 100, color: Colors.white,),
          //           Text("${tab.label} Screen", style: TextStyle(color: Colors.white),),
          //         ],
          //       ),
          //     ),
          //   );
          // }).toList(),
        ),
      ),
    );
  }
}

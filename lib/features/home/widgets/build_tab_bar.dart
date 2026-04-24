import 'package:api_testing/core/constant/app_colors.dart';
import 'package:api_testing/features/home/models/tab_item.dart';
import 'package:flutter/material.dart';
import 'build_tab_item.dart';

class BuildTabBar extends StatelessWidget {
  final List<TabItem> tabs;

  const BuildTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),

        indicator: BoxDecoration(
          color: AppColors.tabIndicator,
          borderRadius: BorderRadius.circular(20),
        ),

        labelColor: AppColors.selectedLabel,
        unselectedLabelColor: AppColors.unselectedLabel,
        dividerColor: Colors.transparent,

        tabs: tabs
            .map((tab) => BuildTabItem(
          icon: tab.icon,
          text: tab.label,
        ))
            .toList(),
      ),
    );
  }
}
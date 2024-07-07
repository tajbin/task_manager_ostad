import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utility/apps_color.dart';

class TaskSummaryCard extends StatelessWidget {
  const TaskSummaryCard({
    super.key, required this.count, required this.title,
  });
  final String count;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppsColor.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(count, style: Theme.of(context).textTheme.titleLarge),
            Text(title, style: Theme.of(context).textTheme.titleSmall,)
          ],
        ),
      ),
    );
  }
}
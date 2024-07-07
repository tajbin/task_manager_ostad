import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/widget/centered_progress_indicator.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../widget/profile_app_bar.dart';
import '../widget/snackbar_message.dart';
import '../widget/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getInProgressTasksInProgress = true;
  List<TaskModel> inProgressTaskList = [];
  @override
  void initState() {
    super.initState();
    _getInProgressTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _getInProgressTasks(),
        child: Visibility(
          visible: _getInProgressTasksInProgress == false,
          replacement: const CenteredProgressIndicator(),
          child: ListView.builder(
              itemCount: inProgressTaskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  taskModel: inProgressTaskList[index],
                  onUpdateTask: () {
                    _getInProgressTasks();
                  },
                );
              }),
        ),
      ),
    );
  }

  Future<void> _getInProgressTasks() async {
    _getInProgressTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.inProgressTask);
    print('Response Status: ${response.isSuccess}');
    print('Response Data: ${response.responseData}');

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      inProgressTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Get In Progress task failed, try again later');
      }
    }
    _getInProgressTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}

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

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _getCanceledTasksInProgress = true;
  List<TaskModel> canceledTask = [];
  @override
  void initState() {
    super.initState();
    _getCanceledTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _getCanceledTasks(),
        child: Visibility(
          visible: _getCanceledTasksInProgress == false,
          replacement: const CenteredProgressIndicator(),
          child: ListView.builder(
              itemCount: canceledTask.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  taskModel: canceledTask[index],
                  onUpdateTask: () {
                    _getCanceledTasks();
                  },
                );
              }),
        ),
      ),
    );
  }

  Future<void> _getCanceledTasks() async {
    _getCanceledTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.canceledTask);
    print('Response Status: ${response.isSuccess}');
    print('Response Data: ${response.responseData}');

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      canceledTask = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Get Canceled task failed, try again later');
      }
    }
    _getCanceledTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}

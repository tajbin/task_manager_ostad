import 'package:flutter/cupertino.dart';
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

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
bool  _getCompletedTasksInProgress = true;
List<TaskModel> completedTaskList = [];
@override
  void initState() {
    super.initState();
    _getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _getCompletedTasks(),
        child: Visibility(
          visible: _getCompletedTasksInProgress == false,
          replacement: const CenteredProgressIndicator(),
          child: ListView.builder(
              itemCount: completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  taskModel: completedTaskList[index], onUpdateTask: () { _getCompletedTasks();  },
                );
              }),
        ),
      ),
    );
  }
  Future<void> _getCompletedTasks() async {
    _getCompletedTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.completedTask);
    print('Response Status: ${response.isSuccess}');
    print('Response Data: ${response.responseData}');

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      completedTaskList = taskListWrapperModel.taskList ?? [];
    }else{
      if (mounted) {
        showSnackBarMessage(context,'Get New task failed, try again later');
      }
    }
    _getCompletedTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

}

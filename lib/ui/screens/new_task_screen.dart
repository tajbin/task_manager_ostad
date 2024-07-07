import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager_ostad/data/models/network_response.dart';
import 'package:task_manager_ostad/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_ostad/data/network_caller/network_caller.dart';
import 'package:task_manager_ostad/ui/screens/add_new_task.dart';
import 'package:task_manager_ostad/ui/utility/apps_color.dart';
import 'package:task_manager_ostad/ui/widget/centered_progress_indicator.dart';
import 'package:task_manager_ostad/ui/widget/snackbar_message.dart';
import '../../data/models/task_count_by_status_wrapper_model.dart';
import '../../data/models/task_count_model.dart';
import '../../data/models/task_model.dart';
import '../../data/utilities/urls.dart';
import '../widget/profile_app_bar.dart';
import '../widget/task_item.dart';
import '../widget/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTasksInProgress = false;
  bool _getTaskCountByStatusInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskCountByStatusModel> taskCountByStatusList = [];

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async => {
                _getNewTasks(),
                _getTaskCountByStatus()
              },
              child: Visibility(
                visible: _getNewTasksInProgress == false,
                replacement: const CenteredProgressIndicator(),
                child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        taskModel: newTaskList[index], onUpdateTask: () {
                        _getNewTasks();
                        _getTaskCountByStatus();
                      },
                      );
                    }),
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppsColor.themeColor,
        foregroundColor: AppsColor.white,
        child: const Icon(Icons.add),
        onPressed: () {
          _onTapAddButton(context);
        },
      ),
    );
  }

  void _onTapAddButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTask(),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child: CenteredProgressIndicator(),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskCountByStatusList.map((e) {
            return TaskSummaryCard(
              count: e.sum.toString(),
              title: (e.sId ?? 'Unknown').toUpperCase(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _getNewTasks() async {
    _getNewTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTask);
    print('Response Status: ${response.isSuccess}');
    print('Response Data: ${response.responseData}');

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Get New task failed, try again later');
      }
    }
    _getNewTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);
    print('Response Status: ${response.isSuccess}');
    print('Response Data: ${response.responseData}');

    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, 'Get Task by count status failed, try again later');
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}

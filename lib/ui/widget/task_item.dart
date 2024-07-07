import 'package:flutter/material.dart';
import 'package:task_manager_ostad/data/models/task_model.dart';
import 'package:task_manager_ostad/ui/widget/centered_progress_indicator.dart';
import 'package:task_manager_ostad/ui/widget/snackbar_message.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utilities/urls.dart';
import '../utility/apps_color.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key, required this.taskModel, required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _editInProgress = false;
  String dropdownValue = '';
  List<String> statusList = [
    'New',
    'InProgress',
    'Completed',
    'Canceled'
  ];
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.taskModel.status!;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
        color: AppsColor.white,
        elevation: 0,
        child: ListTile(
          title: Text(widget.taskModel.title?? ''),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(widget.taskModel.description?? ''),
              Text(
                'Date: ${widget.taskModel.createdDate}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(widget.taskModel.status?? 'New'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 2),
                  ),
                  ButtonBar(
                    children: [
                      Visibility(
                        visible: _deleteInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child: IconButton(
                          onPressed: () {
                            _deleteTasks();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                      Visibility(
                        visible: _editInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.edit),
                          onSelected: (String selectedValue) {
                            dropdownValue = selectedValue;
                            if (mounted) {
                              setState(() {});
                            }
                            _editTasks();
                          },
                          itemBuilder: (BuildContext context) {
                            return statusList.map((String value) {
                              return PopupMenuItem<String>(
                                value: value,
                                child: ListTile(
                                  title: Text(value),
                                  trailing: dropdownValue == value
                                      ? const Icon(Icons.done)
                                      : null,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
  Future<void> _deleteTasks() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Delete failed, try again later');
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
  Future<void> _editTasks() async {
    _editInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.updateTaskStatus(widget.taskModel.sId!, dropdownValue));
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Edit failed, try again later');
      }
    }
    _editInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
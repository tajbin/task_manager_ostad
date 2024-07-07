import 'package:flutter/material.dart';
import 'package:task_manager_ostad/data/models/network_response.dart';
import 'package:task_manager_ostad/data/network_caller/network_caller.dart';
import 'package:task_manager_ostad/ui/widget/background_widget.dart';
import 'package:task_manager_ostad/ui/widget/centered_progress_indicator.dart';
import 'package:task_manager_ostad/ui/widget/profile_app_bar.dart';
import 'package:task_manager_ostad/ui/widget/snackbar_message.dart';

import '../../data/utilities/urls.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleTEController,
                  decoration: const InputDecoration(hintText: 'Title'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionTEController,
                  decoration: const InputDecoration(hintText: 'Description'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Description';
                    }
                    return null;
                  },
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: !_addNewTaskInProgress,
                  replacement: const CenteredProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addNewTask();
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    setState(() {
      _addNewTaskInProgress = true;
    });

    Map<String, dynamic> requestData = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New",
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      Urls.createTask,
      body: requestData,
    );
    _addNewTaskInProgress = false;
    if(mounted){
      setState(() {
      });
    }

    if (response.isSuccess) {
      _clearTextField();
      if (mounted) {
        showSnackBarMessage(context, 'New Task added!');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage ?? 'New Task add failed, try again!');
      }
    }
  }

  void _clearTextField() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}

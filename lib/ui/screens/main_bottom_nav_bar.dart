import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/canceled_task_screen.dart';
import 'package:task_manager_ostad/ui/screens/completed_task_screen.dart';
import 'package:task_manager_ostad/ui/screens/inprogress_task_screen.dart';
import 'package:task_manager_ostad/ui/screens/new_task_screen.dart';
import 'package:task_manager_ostad/ui/utility/apps_color.dart';

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  @override
 int _selectedIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    InProgressTaskScreen(),
    CanceledTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index){
          _selectedIndex = index;
          if(mounted){
            setState(() {});
          }
        },
        selectedItemColor: AppsColor.themeColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'New Task'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'In Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: 'Canceled'),
        ],
      ),
    );
  }
}

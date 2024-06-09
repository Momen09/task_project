import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task1/view/auth_view.dart';
import 'package:task1/view/task_screen.dart';
import 'package:task1/viewmodel/auth_viewmodel.dart';
import 'package:task1/viewmodel/task_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/tasks',
        routes: {
          '/': (context) => Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return authViewModel.isLoggedIn ? TaskListScreen() : LoginScreen();
            },
          ),
          '/tasks': (context) => TaskListScreen(),
        },
      ),
    );
  }
}

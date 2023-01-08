import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/layouts/library_system/home_layout_user.dart';
import 'package:task_library/modules/books_reserveations/books_res.dart';
import 'package:task_library/modules/home_admin/home_screen.dart';
import 'package:task_library/modules/login/login_screen.dart';
import 'package:task_library/shared/cash_helper.dart';
import 'package:task_library/shared/styles/bloc_observal.dart';
import 'package:task_library/shared/styles/constants.dart';
import 'package:task_library/shared/styles/themes.dart';
import 'package:task_library/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await CachHelper.init();
  uid = CachHelper.getData(key: 'uid');
  adminId = CachHelper.getData(key: 'adminId');
  Widget widget;
  if (uid != null) {
    widget = HomeUser();
  } else if (adminId != null) {
    widget = AdminHome();
  } else {
    widget = LoginAdminScreen();
  }

  runApp(MyApp(widget: widget));
}

class MyApp extends StatefulWidget {
  Widget widget;
  MyApp({super.key, required this.widget});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool splash = true;
  @override
  void initState() {
    Timer timer = Timer.periodic(Duration(seconds: 3), (timer) {
      splash = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryCubit()
        ..getCategories()
        ..getMyBooks(),
      child: BlocConsumer<LibraryCubit, LibraryStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Library System',
          theme: LibraryCubit.get(context).isDark ? darkTheme : lightTheme,
          home: splash ? const SplashScreen() : widget.widget,
        ),
      ),
    );
  }
}

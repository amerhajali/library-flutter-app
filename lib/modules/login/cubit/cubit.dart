import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/modules/login/cubit/states.dart';
import 'package:task_library/shared/styles/constants.dart';

class AdminLoginCubit extends Cubit<AdminLoginStates> {
  AdminLoginCubit() : super(AdminLoginInitialState());

  static AdminLoginCubit get(context) => BlocProvider.of(context);

  Future adminLogin(
      {required String email, required String password, context}) async {
    emit(AdminLoginLoadingState());
    print(email + 'emailllll');
    print(password + 'passssssssss');

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .get()
            .then((val) {
          if (val.data()!['isAdmin']) {
            adminId = value.user!.uid;

            // await SocialCubit.get(context).getUserData();
            emit(AdminLoginSuccessState(value.user!.uid));
          } else {
            uid = value.user!.uid;
            emit(LoginSuccessState(uid!));
          }
        });
      },
    ).catchError((error) {
      print(error);
      emit(AdminLoginErrorState(error.toString()));
    });
  }

  AuthMode authMode = AuthMode.Login;
  void switchAuthMode() {
    if (authMode == AuthMode.Login) {
      authMode = AuthMode.SignUp;
    } else {
      authMode = AuthMode.Login;
    }
    emit(ChangeModeState());
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(AdminLoginPasswordState());
  }

  void userRegister(
      {required String email, required String password, required String name}) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print("${value.user!.email} ${value.user!.uid}");
      emit(RegisterSuccessState(value.user!.uid));

      userCreate(email: email, name: name, uid: value.user!.uid);
    }).catchError((error) {
      print(error.toString());
    });
  }

  void userCreate(
      {required String email,
      required String name,
      required String uid,
      bool? isAdmin = false}) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set({'name': name, 'email': email, 'uid': uid, 'isAdmin': isAdmin})
        .then((value) {})
        .catchError((error) {
          print(error.toString());
          emit(RegisterErrorState(error.toString()));
        });
  }
}

enum AuthMode { SignUp, Login }

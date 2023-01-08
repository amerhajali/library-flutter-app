import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/home_layout_user.dart';
import 'package:task_library/modules/home_admin/home_screen.dart';
import 'package:task_library/modules/login/cubit/cubit.dart';
import 'package:task_library/modules/login/cubit/states.dart';
import 'package:task_library/shared/cash_helper.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';

class LoginAdminScreen extends StatelessWidget {
  var emailAdminController = TextEditingController();
  var passAdminController = TextEditingController();
  var nameAdminController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminLoginCubit(),
      child: BlocConsumer<AdminLoginCubit, AdminLoginStates>(
        listener: (context, state) {
          if (state is AdminLoginErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is AdminLoginSuccessState) {
            CachHelper.saveData(key: 'adminId', value: state.adminId)
                .then((value) {
              navigateAndFinish(context, AdminHome());
              // SocialCubit.get(context).getPosts().whenComplete(() {

              // });
            });
            showToast(
                text: "Admin Login successfuly", state: ToastStates.SUCCESS);
          }
          if (state is RegisterSuccessState) {
            CachHelper.saveData(key: 'uid', value: state.uid).then((value) {
              navigateAndFinish(context, HomeUser());
              // SocialCubit.get(context).getPosts().whenComplete(() {

              // });
            });
            showToast(text: "Register successfuly", state: ToastStates.SUCCESS);
          }
          if (state is LoginSuccessState) {
            CachHelper.saveData(key: 'uid', value: state.uid).then((value) {
              navigateAndFinish(context, HomeUser());
              // SocialCubit.get(context).getPosts().whenComplete(() {

              // });
            });
            showToast(text: "Login successfuly", state: ToastStates.SUCCESS);
          }
        },
        builder: (context, state) {
          AdminLoginCubit cubit = AdminLoginCubit.get(context);
          final mediaQuery = MediaQuery.of(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                      height: mediaQuery.size.height * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.secondColor,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/lib.png'))),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //     Positioned(
                    //       right: 80,
                    //       bottom: 30,
                    //       child: Image(
                    //         height: 150,
                    //         fit: BoxFit.contain,
                    //         image: AssetImage('assets/images/lib.png'),
                    //       ),
                    //     ),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      padding: EdgeInsets.all(3),
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.indigo[500],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => cubit.authMode != AuthMode.Login
                                ? cubit.switchAuthMode()
                                : null,
                            child: AnimatedContainer(
                              padding: EdgeInsets.all(10),
                              duration: Duration(milliseconds: 550),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: MyColors.whiteColor,
                                    fontSize:
                                        mediaQuery.size.width > 500 ? 22 : 20),
                              ),
                              decoration: BoxDecoration(
                                  color: cubit.authMode == AuthMode.Login
                                      ? MyColors.primaryColor
                                      : Colors.indigo[500],
                                  borderRadius: BorderRadius.circular(
                                      cubit.authMode == AuthMode.Login
                                          ? 10
                                          : 0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => cubit.authMode == AuthMode.Login
                                ? cubit.switchAuthMode()
                                : null,
                            child: AnimatedContainer(
                              padding: EdgeInsets.all(10),
                              duration: Duration(milliseconds: 550),
                              child: Text('Register',
                                  style: TextStyle(
                                      color: MyColors.whiteColor,
                                      fontSize: mediaQuery.size.width > 500
                                          ? 22
                                          : 20)),
                              decoration: BoxDecoration(
                                  color: cubit.authMode == AuthMode.Login
                                      ? Colors.indigo[500]
                                      : MyColors.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      cubit.authMode == AuthMode.Login
                                          ? 0
                                          : 10)),
                            ),
                          ),
                        ),
                      ]),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      elevation: 20,
                      shadowColor: MyColors.secondColor,
                      child: Container(
                        height: cubit.authMode == AuthMode.Login ? 230 : 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              if (cubit.authMode == AuthMode.SignUp)
                                defaultTextFormField(
                                    controller: nameAdminController,
                                    type: TextInputType.name,
                                    validate: (String? val) {
                                      if (val!.isEmpty) {
                                        return "Name Field Must be exist";
                                      } else {
                                        return null;
                                      }
                                    },
                                    label: "Name",
                                    prefix: Icons.person_outline),
                              if (cubit.authMode == AuthMode.SignUp)
                                SizedBox(
                                  height: 10,
                                ),
                              defaultTextFormField(
                                  controller: emailAdminController,
                                  type: TextInputType.emailAddress,
                                  validate: (String? val) {
                                    if (val!.isEmpty) {
                                      return "Email Must be exist";
                                    } else {
                                      return null;
                                    }
                                  },
                                  label: "Email",
                                  prefix: Icons.email),
                              SizedBox(height: 10),
                              defaultTextFormField(
                                  controller: passAdminController,
                                  type: TextInputType.visiblePassword,
                                  validate: (String? val) {
                                    if (val!.isEmpty) {
                                      return "password Must be exist";
                                    } else {
                                      return null;
                                    }
                                  },
                                  label: "Password",
                                  prefix: Icons.lock,
                                  isPass:
                                      AdminLoginCubit.get(context).isPassword,
                                  suffix: AdminLoginCubit.get(context).suffix,
                                  pressedIcon: () {
                                    AdminLoginCubit.get(context)
                                        .changePasswordVisibility();
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              cubit.authMode == AuthMode.Login
                                  ? defaultButton(
                                      width: mediaQuery.size.width > 500
                                          ? 130
                                          : 110,
                                      function: () {
                                        if (formKey.currentState!.validate()) {
                                          AdminLoginCubit.get(context)
                                              .adminLogin(
                                                  email:
                                                      emailAdminController.text,
                                                  password:
                                                      passAdminController.text,
                                                  context: context);
                                        }
                                      },
                                      text: "Login")
                                  : defaultButton(
                                      width: mediaQuery.size.width > 500
                                          ? 140
                                          : 115,
                                      function: () {
                                        if (formKey.currentState!.validate()) {
                                          AdminLoginCubit.get(context)
                                              .userRegister(
                                                  email:
                                                      emailAdminController.text,
                                                  password:
                                                      passAdminController.text,
                                                  name:
                                                      nameAdminController.text);
                                        }
                                      },
                                      text: "Register")
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

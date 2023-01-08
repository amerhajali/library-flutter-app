import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/shared/styles/constants.dart';
import 'package:task_library/shared/styles/themes.dart';

Widget defaultButton(
        {double? width = double.infinity,
        Color? background = MyColors.secondColor,
        required Function() function,
        required String text,
        context}) =>
    Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: background,
        onPressed: function,
        child: Text(
          "$text",
          style: context == null
              ? TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)
              : Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );

Widget defaultTextFormField(
        {required TextEditingController controller,
        required TextInputType type,
        Function(String)? onsubmit,
        String? Function(String?)? onchange,
        Function()? onTap,
        Function()? pressedIcon,
        String? Function(String?)? validate,
        required String label,
        bool isClickable = true,
        required IconData? prefix,
        IconData? suffix,
        bool isPass = false,
        Color? errorColor = Colors.red,
        Color? cursorColor = defaultColor}) =>
    TextFormField(
        validator: validate,
        controller: controller,
        keyboardType: type,
        obscureText: isPass,
        enabled: isClickable,
        onTap: onTap,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: errorColor),
          focusColor: cursorColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: cursorColor!,
              )),
          prefixIcon: Icon(
            prefix,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            icon: Icon(suffix),
            onPressed: pressedIcon,
          ),
          label: Text(
            "$label",
            style: TextStyle(fontSize: 16),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onFieldSubmitted: onsubmit);

Widget myDivider() => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    );

Widget CategItem(Map item, context, index) => Container(
      color: Colors.indigo[200],
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/3843/3843517.png'))),
              ),
              SizedBox(
                width: 20,
              ),
              // Expanded(
              //   child: Container(
              //     height: 120,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Expanded(
              //           child: Text(
              //             'Title',
              //             style: Theme.of(context).textTheme.bodyText1,
              //             maxLines: 3,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ),
              //         Text(
              //           'Content',
              //           style: TextStyle(color: Colors.grey),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );

Future showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 18.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color? chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green[800];
    case ToastStates.ERROR:
      return Colors.red[800];
    case ToastStates.WARNING:
      return Colors.orange[800];
  }
}

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (rout) => false);

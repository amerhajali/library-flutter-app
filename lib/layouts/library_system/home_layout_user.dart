import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/modules/favorites_books/favorites_screen.dart';
import 'package:task_library/modules/login/login_screen.dart';
import 'package:task_library/shared/cash_helper.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/themes.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LibraryCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(LibraryCubit.get(context)
                .titles[LibraryCubit.get(context).currentIndex]),
            actions: [
              InkWell(
                  onTap: () {
                    CachHelper.sharedPreferences.clear();
                    FirebaseAuth.instance.signOut();
                    navigateAndFinish(context, LoginAdminScreen());
                  },
                  child: Center(child: Text('LOGOUT'))),
              SizedBox(
                width: 10,
              ),
              if (MediaQuery.of(context).size.width > 700)
                Center(
                  child: IconButton(
                      onPressed: LibraryCubit.get(context).changeMode,
                      iconSize: 30,
                      icon: Icon(Icons.brightness_4_outlined)),
                ),
              if (MediaQuery.of(context).size.width < 700)
                Center(
                  child: IconButton(
                      onPressed: LibraryCubit.get(context).changeMode,
                      icon: Icon(Icons.brightness_4_outlined)),
                ),
              if (MediaQuery.of(context).size.width > 700)
                Center(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart_checkout_outlined),
                    iconSize: 30,
                    onPressed: () {
                      LibraryCubit.get(context).getFavorites();
                      print(LibraryCubit.get(context).booksFav);
                      navigateTo(context, FavBooks());
                    },
                  ),
                ),
              if (MediaQuery.of(context).size.width < 700)
                Center(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart_checkout_outlined),
                    onPressed: () {
                      LibraryCubit.get(context).getFavorites();
                      print(LibraryCubit.get(context).booksFav);
                      navigateTo(context, FavBooks());
                    },
                  ),
                ),
              // IconButton(
              //   icon: Icon(IconBroken.Search),
              //   onPressed: () {},
              // ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.width > 800 ? 90 : 65,
            child: BottomNavigationBar(
              unselectedFontSize:
                  MediaQuery.of(context).size.width > 800 ? 16 : 13,
              selectedFontSize:
                  MediaQuery.of(context).size.width > 800 ? 20 : 16,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: MediaQuery.of(context).size.width > 800 ? 30 : 22,
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.category,
                      size: MediaQuery.of(context).size.width > 800 ? 30 : 22,
                    ),
                    label: 'Sections'),
              ],
              onTap: cubit.changeBottomNav,
              currentIndex: cubit.currentIndex,
            ),
          ),
        );
      },
    );
  }
}

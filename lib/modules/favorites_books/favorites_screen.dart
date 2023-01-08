import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/modules/login/login_screen.dart';
import 'package:task_library/shared/cash_helper.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';
import 'package:task_library/shared/styles/themes.dart';

class FavBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: (context, state) {
        if (state is BuyFavSuccessState) {
          LibraryCubit.get(context).getMyBooks().whenComplete(() {});
          showToast(
              text: 'You bought all items which you selected',
              state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Shopping Cart'),
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
                Center(
                  child: IconButton(
                      iconSize: 30,
                      onPressed: LibraryCubit.get(context).changeMode,
                      icon: Icon(Icons.brightness_4_outlined)),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  LibraryCubit.get(context).buy();
                },
                child: Text(
                  'Buy',
                  style: TextStyle(fontSize: 20),
                )),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 20,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: state is GetFavLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : LibraryCubit.get(context).favorites.isEmpty
                                ? const Center(
                                    child: Text(
                                        'you did not added favorites books yet'),
                                  )
                                : ListView.separated(
                                    itemCount: LibraryCubit.get(context)
                                        .booksFav
                                        .length,
                                    separatorBuilder: (context, index) =>
                                        myDivider(),
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 10,
                                        color: index % 2 == 0
                                            ? MyColors.primaryColor
                                            : MyColors.secondColor,
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 120,
                                                decoration: BoxDecoration(
                                                    color: defaultColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Image.network(
                                                  LibraryCubit.get(context)
                                                      .booksFav[index]
                                                      .image!,
                                                  height: 100,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      LibraryCubit.get(context)
                                                          .booksFav[index]
                                                          .name!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                    Text(
                                                      'Cost = ${LibraryCubit.get(context).booksFav[index].cost} \$',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircleAvatar(
                                                backgroundColor: index % 2 == 1
                                                    ? MyColors.primaryColor
                                                    : MyColors.secondColor,
                                                radius: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        700
                                                    ? 30
                                                    : 20,
                                                child: IconButton(
                                                    onPressed: () {
                                                      LibraryCubit.get(context)
                                                          .removeBookCart(
                                                              idCateg:
                                                                  LibraryCubit.get(
                                                                          context)
                                                                      .booksFav[
                                                                          index]
                                                                      .categ!,
                                                              index: index);
                                                    },
                                                    icon: Icon(
                                                      Icons.cancel_outlined,
                                                      size:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  700
                                                              ? 35
                                                              : 22,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        'Total cost is ${LibraryCubit.get(context).total}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/modules/add_book/add_book.dart';
import 'package:task_library/modules/books/books_screen.dart';
import 'package:task_library/modules/login/login_screen.dart';
import 'package:task_library/shared/cash_helper.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';
import 'package:task_library/shared/styles/themes.dart';

class AdminHome extends StatelessWidget {
  var categoryController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: (context, state) {
        if (state is CreateCategorySuccessState) {
          showToast(text: 'Added Successfully', state: ToastStates.SUCCESS);
        }
        if (state is CreateCategoryErrorState) {
          showToast(
              text: 'Added Field ${state.error}', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        final mediaQuery = MediaQuery.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Admin Panel'),
            actions: [
              InkWell(
                  onTap: () {
                    CachHelper.sharedPreferences.clear();
                    FirebaseAuth.instance.signOut();
                    navigateAndFinish(context, LoginAdminScreen());
                  },
                  child: Center(child: Text('LOGOUT'))),
              Center(
                child: IconButton(
                    onPressed: LibraryCubit.get(context).changeMode,
                    icon: Icon(Icons.brightness_4_outlined)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 160,
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          defaultTextFormField(
                              controller: categoryController,
                              errorColor: Colors.white70,
                              type: TextInputType.name,
                              cursorColor: Colors.white,
                              validate: (String? val) {
                                if (val!.isEmpty) {
                                  return "Category Field Must be not Empty";
                                } else {
                                  return null;
                                }
                              },
                              label: "Category",
                              prefix: Icons.category_outlined),
                          SizedBox(
                            height: 5,
                          ),
                          defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  LibraryCubit.get(context).createCategory(
                                      name: categoryController.text);
                                }
                              },
                              text: 'Create',
                              width: 90)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    navigateTo(
                        context,
                        AddBookScreen(
                          forEdit: false,
                          book: {},
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: defaultColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Book from Here',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.indigo),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://thumbs.dreamstime.com/b/open-book-icon-isolated-white-background-design-concept-simple-vector-logo-177854318.jpg'))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 10, right: 10, bottom: 5),
                  child: myDivider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CATEGORIES',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/3843/3843517.png'))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: mediaQuery.size.width > 700
                        ? mediaQuery.size.height * 0.5
                        : mediaQuery.size.height * 0.4,
                    child: Card(
                      elevation: 10,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: state is GetCategoryLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    LibraryCubit.get(context).getBooks(
                                        categ: LibraryCubit.get(context)
                                            .categories[index]
                                            .id!);
                                    navigateTo(
                                        context,
                                        BooksScreen(true,
                                            categ: LibraryCubit.get(context)
                                                .categories[index]));
                                  },
                                  child: Container(
                                      color: Colors.indigo[300],
                                      padding: EdgeInsets.all(10),
                                      height: 100,
                                      child: ListTile(
                                        title: Text(
                                          LibraryCubit.get(context)
                                              .categories[index]
                                              .name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        trailing: Container(
                                          width: 100,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                child: IconButton(
                                                  icon:
                                                      Icon(Icons.arrow_forward),
                                                  onPressed: () {
                                                    LibraryCubit.get(context)
                                                        .getBooks(
                                                            categ: LibraryCubit
                                                                    .get(
                                                                        context)
                                                                .categories[
                                                                    index]
                                                                .id!);
                                                    navigateTo(
                                                        context,
                                                        BooksScreen(
                                                          true,
                                                          categ: LibraryCubit
                                                                  .get(context)
                                                              .categories[index],
                                                        ));
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    LibraryCubit.get(context)
                                                        .deleteCateg(
                                                            idCateg: LibraryCubit
                                                                    .get(
                                                                        context)
                                                                .categories);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return myDivider();
                              },
                              itemCount:
                                  LibraryCubit.get(context).categories.length),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

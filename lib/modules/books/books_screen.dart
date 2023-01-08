import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/models/book_mdel.dart';
import 'package:task_library/modules/add_book/add_book.dart';
import 'package:task_library/modules/login/login_screen.dart';
import 'package:task_library/shared/cash_helper.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';
import 'package:task_library/shared/styles/themes.dart';

class BooksScreen extends StatelessWidget {
  final bool isAdmin;
  CategModel? categ;
  BooksScreen(this.isAdmin, {this.categ});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Books'),
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
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: state is GetBooksLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : LibraryCubit.get(context).books.isEmpty
                                    ? const Center(
                                        child: Text('no found books yet'),
                                      )
                                    : GridView(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      400
                                                  ? 0.62
                                                  : MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          800
                                                      ? 1.6
                                                      : 1.1,
                                        ),
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                            LibraryCubit.get(context)
                                                .books
                                                .length,
                                            (index) => Card(
                                                  elevation: 5,
                                                  child: Container(
                                                    height: 100,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topStart,
                                                            children: [
                                                              Image(
                                                                image: NetworkImage(
                                                                    LibraryCubit.get(context)
                                                                            .books[index]
                                                                        [
                                                                        'image']),
                                                                width: double
                                                                    .infinity,
                                                                height: 200,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              if (LibraryCubit.get(
                                                                          context)
                                                                      .books[index]
                                                                  [
                                                                  'availability'])
                                                                Container(
                                                                  color: Colors
                                                                      .green,
                                                                  child: Text(
                                                                    'Availabile',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              if (!LibraryCubit.get(
                                                                          context)
                                                                      .books[index]
                                                                  [
                                                                  'availability'])
                                                                Container(
                                                                  color: Colors
                                                                      .red,
                                                                  child: Text(
                                                                    'Not Availabile',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  if (isAdmin)
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        LibraryCubit.get(context).deleteBook(
                                                                            categ:
                                                                                LibraryCubit.get(context).books[index]['categ'],
                                                                            idBook: LibraryCubit.get(context).books[index]['id'],
                                                                            index: index);
                                                                        LibraryCubit.get(context).getBooks(
                                                                            categ:
                                                                                LibraryCubit.get(context).books[index]['categ']);
                                                                      },
                                                                      child: Container(
                                                                          color: Colors.red,
                                                                          child: Icon(
                                                                            Icons.delete_forever_outlined,
                                                                            size:
                                                                                25,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                    )
                                                                ],
                                                              )
                                                            ]),
                                                        Spacer(),
                                                        Text(
                                                          LibraryCubit.get(
                                                                      context)
                                                                  .books[index]
                                                              ['name'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle1,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                '${LibraryCubit.get(context).books[index]['cost']}\$',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color:
                                                                        defaultColor),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .bookmark_add_outlined,
                                                                    color:
                                                                        defaultColor,
                                                                  ),
                                                                  Text(
                                                                    isAdmin
                                                                        ? '${LibraryCubit.get(context).books[index]['fav']}'
                                                                        : '${LibraryCubit.get(context).books[index]['quantity']}',
                                                                    style: TextStyle(
                                                                        color:
                                                                            defaultColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: IconButton(
                                                                  onPressed: isAdmin
                                                                      ? () {
                                                                          navigateTo(
                                                                              context,
                                                                              AddBookScreen(categ: categ!, book: LibraryCubit.get(context).books[index], forEdit: true, index: index));
                                                                        }
                                                                      : LibraryCubit.get(context).favorites.contains(LibraryCubit.get(context).books[index]['id'])
                                                                          ? () {
                                                                              LibraryCubit.get(context).removeBook(idCateg: categ!.id!, index: index);
                                                                            }
                                                                          : () {
                                                                              if (LibraryCubit.get(context).books[index]['availability']) {
                                                                                LibraryCubit.get(context).favBook(idCateg: categ!.id!, index: index);
                                                                              } else {
                                                                                showToast(text: 'the book is not availabile', state: ToastStates.ERROR);
                                                                              }
                                                                            },
                                                                  icon:
                                                                      // edit or favorite
                                                                      isAdmin
                                                                          ? CircleAvatar(
                                                                              backgroundColor: defaultColor,
                                                                              radius: MediaQuery.of(context).size.width > 700 ? 24 : 15,
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                size: MediaQuery.of(context).size.width > 700 ? 28 : 20,
                                                                                color: Colors.white,
                                                                              ))
                                                                          : CircleAvatar(
                                                                              backgroundColor:
                                                                                  // LibraryCubit.get(context)
                                                                                  //             .books[index]['']
                                                                                  LibraryCubit.get(context).favorites.contains(LibraryCubit.get(context).books[index]['id']) ? Colors.red : defaultColor,
                                                                              radius: MediaQuery.of(context).size.width > 700 ? 30 : 20,
                                                                              child: Icon(
                                                                                LibraryCubit.get(context).favorites.contains(LibraryCubit.get(context).books[index]['id']) ? Icons.cancel_outlined : Icons.add_shopping_cart_outlined,
                                                                                size: MediaQuery.of(context).size.width > 700 ? 30 : 20,
                                                                                color: Colors.white,
                                                                              ))),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                        shrinkWrap: true,
                                      )

                            // : GridView(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     shrinkWrap: true,
                            //     crossAxisCount: 2,
                            //     crossAxisSpacing: 2,
                            //     mainAxisSpacing: 2,
                            //     childAspectRatio: 1.5,
                            //     children: ),
                            )),
                  ],
                ),
              ));
        });
  }
}

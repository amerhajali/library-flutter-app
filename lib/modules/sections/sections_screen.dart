import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/modules/books/books_screen.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';

class Sections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: state is GetCategoryLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : LibraryCubit.get(context).categories.isEmpty
                    ? const Center(
                        child: Text('No found categories yet'),
                      )
                    : Card(
                        elevation: 10,
                        margin: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          itemCount:
                              LibraryCubit.get(context).categories.length,
                          separatorBuilder: (context, index) => myDivider(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                LibraryCubit.get(context).getBooks(
                                    categ: LibraryCubit.get(context)
                                        .categories[index]
                                        .id!);
                                navigateTo(
                                    context,
                                    BooksScreen(false,
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
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    trailing: Container(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment: adminId == null
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            child: IconButton(
                                              icon: Icon(Icons.arrow_forward),
                                              onPressed: () {
                                                LibraryCubit.get(context)
                                                    .getBooks(
                                                        categ: LibraryCubit.get(
                                                                context)
                                                            .categories[index]
                                                            .id!);
                                                navigateTo(
                                                    context,
                                                    BooksScreen(
                                                      false,
                                                      categ: LibraryCubit.get(
                                                              context)
                                                          .categories[index],
                                                    ));
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          if (adminId != null)
                                            CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                      ));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/themes.dart';

class ResBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.center,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20)),
                child: Text('My Books',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: 30)),
              ),
            ),
            Expanded(
              child: state is GetMyBooksLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : LibraryCubit.get(context).myBooks.isEmpty
                      ? const Center(
                          child: Text('you did not added favorites books yet'),
                        )
                      : ListView.separated(
                          itemCount: LibraryCubit.get(context).myBooks.length,
                          separatorBuilder: (context, index) => myDivider(),
                          itemBuilder: (context, index) {
                            return Card(
                              color: defaultColor,
                              elevation: 10,
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
                                              BorderRadius.circular(20)),
                                      child: Image.network(
                                        LibraryCubit.get(context)
                                            .myBooks[index]
                                            .image!,
                                        height: 100,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            LibraryCubit.get(context)
                                                .myBooks[index]
                                                .name!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                          Text(
                                            'Cost = ${LibraryCubit.get(context).myBooks[index].cost} \$',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                          Text(
                                            '${LibraryCubit.get(context).myBooks[index].time!.toDate()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // IconButton(
                                    //     onPressed: () {
                                    //       LibraryCubit.get(context).removeBook(
                                    //           idCateg: LibraryCubit.get(context)
                                    //               .myBooks[index]
                                    //               .categ!,
                                    //           index: index);
                                    //     },
                                    //     icon: CircleAvatar(
                                    //         backgroundColor: Colors.red,
                                    //         radius: MediaQuery.of(context)
                                    //                     .size
                                    //                     .width >
                                    //                 700
                                    //             ? 30
                                    //             : 20,
                                    //         child: Icon(
                                    //           Icons.cancel_outlined,
                                    //           size: MediaQuery.of(context)
                                    //                       .size
                                    //                       .width >
                                    //                   700
                                    //               ? 30
                                    //               : 20,
                                    //           color: Colors.white,
                                    //         ))),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            )
          ],
        ));
      },
    );
  }
}

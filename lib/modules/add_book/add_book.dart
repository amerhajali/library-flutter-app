import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_library/layouts/library_system/cubit/cubit.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/models/book_mdel.dart';
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';
import 'package:task_library/shared/styles/themes.dart';

class AddBookScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameBookController = TextEditingController();
  var quantityBookController = TextEditingController();
  var costBookController = TextEditingController();
  final bool forEdit;
  final Map book;
  CategModel? categ;
  int? index;
  AddBookScreen(
      {required this.forEdit, required this.book, this.categ, this.index});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryCubit, LibraryStates>(
      listener: (context, state) {
        if (state is CreateBookSuccessState) {
          showToast(
              text: 'Added book successfully', state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        if (forEdit && LibraryCubit.get(context).dropdownvalue == categ) {
          nameBookController.text = book['name'];
          quantityBookController.text = '${book['quantity']}';
          costBookController.text = '${book['cost']}';
          LibraryCubit.get(context).dropdownvalue = categ;
        }
        // if (!forEdit) {
        //   CategModel categModel = CategModel(
        //       LibraryCubit.get(context).categories[0].id,
        //       LibraryCubit.get(context).categories[0].name);
        //   LibraryCubit.get(context).changeDropList(categModel);
        // }
        return Scaffold(
          appBar: AppBar(
            title: forEdit ? Text('Edit Info') : Text('Add Book'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          defaultTextFormField(
                              controller: nameBookController,
                              errorColor: Colors.white,
                              type: TextInputType.name,
                              cursorColor: Colors.white,
                              validate: (String? val) {
                                if (val!.isEmpty) {
                                  return "Name Field Must be not Empty";
                                } else {
                                  return null;
                                }
                              },
                              label: "Name",
                              prefix: Icons.edit),
                          SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                              controller: quantityBookController,
                              errorColor: Color.fromRGBO(255, 255, 255, 1),
                              type: TextInputType.number,
                              cursorColor: Colors.white,
                              validate: (String? val) {
                                if (val!.isEmpty) {
                                  return "Quantity Field Must be not Empty";
                                } else {
                                  return null;
                                }
                              },
                              label: "Quantity",
                              prefix: Icons.numbers_outlined),
                          SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                              controller: costBookController,
                              errorColor: Colors.white,
                              type: TextInputType.number,
                              cursorColor: Colors.white,
                              validate: (String? val) {
                                if (val!.isEmpty) {
                                  return "Cost Field Must be not Empty";
                                } else {
                                  return null;
                                }
                              },
                              label: "Cost",
                              prefix: Icons.attach_money_outlined),
                          SizedBox(
                            height: 10,
                          ),
                          if (!forEdit)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  LibraryCubit.get(context).getBookImage();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  color: defaultColor,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Upload photo',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                MyColors.primaryColor,
                                            child: Icon(
                                              Icons.photo_album_outlined,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          if (LibraryCubit.get(context).bookImage != null)
                            Text('Done uploaded your image'),
                          SizedBox(
                            height: 5,
                          ),
                          DropdownButton(
                            value: LibraryCubit.get(context).dropdownvalue!,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: LibraryCubit.get(context)
                                .categories
                                .map((CategModel item) {
                              return DropdownMenuItem<CategModel>(
                                value: item,
                                child: Text(item.name!),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              LibraryCubit.get(context)
                                  .changeDropList(newValue);
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          forEdit
                              ? defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      LibraryCubit.get(context).updateBook(
                                          name: nameBookController.text,
                                          quantity: int.parse(
                                              quantityBookController.text),
                                          cost: double.parse(
                                              costBookController.text),
                                          idCateg: LibraryCubit.get(context)
                                              .dropdownvalue!
                                              .id!,
                                          prevCateg: book['categ'],
                                          idBook: book['id'],
                                          index: index!);
                                      nameBookController.clear();
                                      quantityBookController.clear();
                                      costBookController.clear();
                                      LibraryCubit.get(context)
                                          .getBooks(categ: categ!.id!);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  text: 'Edit',
                                  width: 90,
                                )
                              : defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      LibraryCubit.get(context).createBook(
                                          name: nameBookController.text,
                                          quantity: int.parse(
                                              quantityBookController.text),
                                          cost: double.parse(
                                              costBookController.text),
                                          idCateg: LibraryCubit.get(context)
                                              .dropdownvalue!
                                              .id!);
                                      LibraryCubit.get(context).bookImage =
                                          null;
                                      nameBookController.clear();
                                      quantityBookController.clear();
                                      costBookController.clear();

                                      Navigator.of(context).pop();
                                    }
                                  },
                                  text: 'Add',
                                  width: 90)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// DropdownButton(
               
//               // Initial Value
//               value: dropdownvalue,
               
//               // Down Arrow Icon
//               icon: const Icon(Icons.keyboard_arrow_down),   
               
//               // Array list of items
//               items: items.map((String items) {
//                 return DropdownMenuItem(
//                   value: items,
//                   child: Text(items),
//                 );
//               }).toList(),
//               // After selecting the desired option,it will
//               // change button value to selected value
//               onChanged: (String? newValue) {
//                 setState(() {
//                   dropdownvalue = newValue!;
//                 });
//               },
//             )
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_library/layouts/library_system/cubit/states.dart';
import 'package:task_library/models/book_mdel.dart';
import 'package:task_library/modules/books/books_screen.dart';
import 'package:task_library/modules/books_reserveations/books_res.dart';
import 'package:task_library/modules/sections/sections_screen.dart';
import 'package:task_library/shared/cash_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:task_library/shared/components.dart';
import 'package:task_library/shared/styles/constants.dart';

class LibraryCubit extends Cubit<LibraryStates> {
  LibraryCubit() : super(LibraryInitialState());

  static LibraryCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeMode({bool? fromCached}) {
    if (fromCached != null) {
      isDark = fromCached;
      emit(ChangeModeThemeState());
    } else {
      isDark = !isDark;
      CachHelper.putData(key: "isDark", value: isDark).then(
        (value) {
          emit(ChangeModeThemeState());
        },
      );
    }
  }

  Future createCategory({required String name}) async {
    await FirebaseFirestore.instance.collection('category').add({
      'name': name,
    }).then((value) {
      emit(CreateCategorySuccessState());
      getCategories();
    }).catchError((error) {
      emit(CreateCategoryErrorState(error.toString()));
    });
  }

  Future createBook(
      {required String name,
      required int quantity,
      required double cost,
      required String idCateg}) async {
    if (bookImage == null) {
      await FirebaseFirestore.instance.collection('books').add({
        'name': name,
        'quantity': quantity,
        'cost': cost,
        'categ': idCateg,
        'availability': quantity == 0 ? false : true,
        'image':
            'https://img.freepik.com/free-psd/book-cover-mockup_125540-572.jpg?w=2000',
        'fav': 0
      }).whenComplete(() {
        Future.delayed(Duration(seconds: 1), () {
          emit(CreateBookSuccessState());
        });
      }).catchError((error) {
        emit(CreateBookErrorState(error.toString()));
      });
    } else {
      emit(BookImagePickedLoadingState());
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(bookImage!.path).pathSegments.last}')
          .putFile(bookImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) async {
          await FirebaseFirestore.instance.collection('books').add({
            'name': name,
            'quantity': quantity,
            'cost': cost,
            'categ': idCateg,
            'availability': quantity == 0 ? false : true,
            'image': value,
            'fav': 0
          }).whenComplete(() {
            Future.delayed(Duration(seconds: 1), () {
              emit(CreateCategorySuccessState());
            });
          }).catchError((error) {
            emit(CreateCategoryErrorState(error.toString()));
          });
        });
      });
    }
  }

  Future deleteCateg({required idCateg}) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(idCateg)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('books')
          .where('categ', isEqualTo: idCateg)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
        getCategories();
      });
    });
  }

  Future deleteBook(
      {required String categ,
      required String idBook,
      required int index}) async {
    FirebaseFirestore.instance
        .collection('books')
        .doc(idBook)
        .delete()
        .then((value) {
      books.removeAt(index);
      // getBooks(categ: categ);
      emit(DeleteBookSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(DeleteBookErrorState(error.toString()));
    });
  }

  Future updateBook(
      {required String name,
      required int quantity,
      required double cost,
      required String idCateg,
      required String prevCateg,
      required String idBook,
      required int index}) async {
    if (idCateg == prevCateg) {
      await FirebaseFirestore.instance.collection('books').doc(idBook).update({
        'name': name,
        'quantity': quantity,
        'cost': cost,
      }).whenComplete(() {
        Future.delayed(Duration(seconds: 1), () {
          emit(UpdateBookSuccessState());
        });
      }).catchError((error) {
        emit(UpdateBookErrorState(error.toString()));
      });
    } else {
      getBook(idBook: idBook).whenComplete(() {
        FirebaseFirestore.instance.collection('books').doc(idBook).set({
          'name': name,
          'quantity': quantity,
          'cost': cost,
          'availability': book!['availability'],
          'image': book!['image'],
          'categ': idCateg,
          'fav': book!['fav'],
        }).then((value) {
          books.removeAt(index);
          Future.delayed(const Duration(seconds: 1), () {
            emit(UpdateBookSuccessState());
          });
        }).catchError((er) {
          print(er.toString());
        });
      });
    }
  }

  List<CategModel> categories = [];

  Future getCategories() async {
    emit(GetCategoryLoadingState());
    categories = [];
    await FirebaseFirestore.instance
        .collection('category')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            CategModel model = CategModel(element.id, element.data()['name']);
            categories.add(model);
          });
        })
        .whenComplete(() => Future.delayed(Duration(seconds: 1), () {
              dropdownvalue = categories[0];

              emit(GetCategorySuccessState());
            }))
        .catchError((error) {
          emit(GetCategoryErrorState(error.toString()));
        });
  }

  Map<dynamic, dynamic>? book;

  Future getBook({required String idBook}) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(idBook)
        .get()
        .then((value) {
      book = {
        'categ': value.data()!['categ'],
        'name': value.data()!['name'],
        'image': value.data()!['image'],
        'quantity': value.data()!['quantity'],
        'availability': value.data()!['availability'],
        'cost': value.data()!['cost'],
        'fav': value.data()!['fav'],
      };
    }).catchError((error) {
      print(error);
    });
  }

  List<Map> books = [];
  Future getBooks({required String categ}) async {
    emit(GetBooksLoadingState());
    books = [];
    await FirebaseFirestore.instance
        .collection('books')
        .where('categ', isEqualTo: categ)
        .get()
        .then((value) {
          value.docs.forEach((element) {
            books.add({
              'name': element.data()['name'],
              'id': element.id,
              'fav': element.data()['fav'],
              'quantity': element.data()['quantity'],
              'cost': element.data()['cost'],
              'availability': element.data()['availability'],
              'categ': element.data()['categ'],
              'image': element.data()['image'],
            });
          });
        })
        .whenComplete(() => Future.delayed(Duration(seconds: 1), () {
              emit(GetBooksSuccessState());
            }))
        .catchError((error) {
          emit(GetBooksErrorState(error.toString()));
        });
  }

  CategModel? dropdownvalue;

  File? bookImage;
  var picker = ImagePicker();
  Future<void> getBookImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      bookImage = File(pickedFile.path);
      print(bookImage!.path);
      emit(BookImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(BookImagePickedErrorState("No image selected"));
    }
  }

  void changeDropList(Object? newValue) {
    dropdownvalue = newValue as CategModel;
    emit(ChangeSelectionListState());
  }

  int currentIndex = 0;

  List<Widget> screens = [
    ResBooks(),
    Sections(),
  ];
  List titles = ['Library System', "Sections"];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
    if (index == 0) {
      getMyBooks();
    }
  }

  List<BookModel> booksFav = [];
  List<BookModel> buyBooks = [];
  List<BookModel> myBooks = [];

  Future getFavorites() async {
    favorites = [];
    booksFav = [];
    // print();
    emit(GetFavLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      favorites = List.from(value.data()!['favorites']);
      print(favorites);
      favorites.forEach((element) {
        print(element);
        FirebaseFirestore.instance
            .collection('books')
            .doc(element)
            .get()
            .then((value) {
          //add every id
          BookModel bookModel = BookModel.fromJson({
            'name': value.data()!['name'],
            'id': value.id,
            'cost': value.data()!['cost'],
            'image': value.data()!['image'],
            'availability': value.data()!['availability'],
            'quantity': value.data()!['quantity'],
            'fav': value.data()!['fav'],
            'categ': value.data()!['categ']
          });
          booksFav.add(bookModel);
        });
      });
    }).whenComplete(() {
      Future.delayed(Duration(seconds: 1), () {
        clcCost();
        emit(GetFavSuccessState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetFavErrorState(error.toString()));
    });
  }

  List<String> favorites = [];

  Future favBook({required String idCateg, index}) async {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'favorites': FieldValue.arrayUnion([books[index]['id']])
    }).then((value) {
      favorites.add(books[index]['id']);
      emit(AddFavSuccessState());
    });
  }

  double total = 0;
  void clcCost() {
    total = 0;
    booksFav.forEach((element) {
      total = total + element.cost!;
    });
  }

  Future removeBook({required String idCateg, index}) async {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'favorites': FieldValue.arrayRemove([books[index]['id']])
    }).then((value) async {
      await getFavorites();
      clcCost();
      emit(DeleteFavSuccessState());
    });
  }

  Future removeBookCart({required String idCateg, index}) async {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'favorites': FieldValue.arrayRemove([booksFav[index].id])
    }).then((value) async {
      await getFavorites();
      clcCost();
      emit(DeleteFavSuccessState());
    });
  }

  Future buyBooksFun({index}) async {
    // await FirebaseFirestore.instance
    //     .collection('books')
    //     .doc(idBook)
    //     .get()
    //     .then((value) async {
    //   print(value.data());

    // buyBooks.add(BookModel.fromJson({
    //   'time': DateTime.now(),
    //   'name': value.data()!['name'],
    //   'id': value.id,
    //   'cost': value.data()!['cost'],
    //   'image': value.data()!['image'],
    //   'availability': value.data()!['availability'],
    //   'quantity': value.data()!['quantity'],
    //   'fav': value.data()!['fav'],
    //   'categ': value.data()!['categ']
    // }));

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('books')
        .add({
      'time': DateTime.now(),
      // '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} - ${DateTime.now().hour}:${DateTime.now().minute}',
      'name': booksFav[index].name,
      'id': booksFav[index].id,
      'cost': booksFav[index].cost,
      'categ': booksFav[index].categ,
      'image': booksFav[index].image,
    }).then((val) {
      FirebaseFirestore.instance
          .collection('books')
          .doc(booksFav[index].id)
          .update({
        'fav': booksFav[index].fav! + 1,
        'availability': (booksFav[index].fav! + 1) == booksFav[index].quantity
            ? false
            : true
      });
    });

    // });
  }

  void buy() async {
    List<bool> availabiles = [];
    booksFav.forEach((element) {
      availabiles.add(element.availability!);
    });
    if (availabiles.contains(false)) {
      showToast(
          text: 'some books not availabile please delete it',
          state: ToastStates.ERROR);
    } else {
      for (int i = 0; i < booksFav.length; i++) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('books')
            .add({
          'time': DateTime.now(),
          // '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} - ${DateTime.now().hour}:${DateTime.now().minute}',
          'name': booksFav[i].name,
          'id': booksFav[i].id,
          'cost': booksFav[i].cost,
          'categ': booksFav[i].categ,
          'image': booksFav[i].image,
        }).then((val) {
          // print(i);
          // print(booksFav[i].id);

          FirebaseFirestore.instance
              .collection('books')
              .doc(booksFav[i].id)
              .update({
            'fav': (booksFav[i].fav! + 1),
            'availability':
                (booksFav[i].fav! + 1) == booksFav[i].quantity ? false : true
          });
        });
      }
      booksFav = [];
      favorites = [];
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'favorites': []}).then((value) {
        emit(BuyFavSuccessState());
      });
    }
  }

  Future getMyBooks() async {
    emit(GetMyBooksLoadingState());
    myBooks = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('books')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        myBooks.add(BookModel.fromJson({
          'name': element.data()['name'],
          'id': element.data()['id'],
          'categ': element.data()['categ'],
          'cost': element.data()['cost'],
          'time': element.data()['time'],
          'image': element.data()['image'],
        }));
      });
    }).whenComplete(() {
      Future.delayed(Duration(seconds: 1), () {
        emit(GetMyBooksSuccessState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetMyBooksErrorState(error.toString()));
    });
  }
}

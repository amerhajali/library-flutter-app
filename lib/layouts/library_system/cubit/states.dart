abstract class LibraryStates {}

class LibraryInitialState extends LibraryStates {}

class ChangeModeThemeState extends LibraryStates {}

class CreateCategorySuccessState extends LibraryStates {}

class CreateCategoryErrorState extends LibraryStates {
  final String error;
  CreateCategoryErrorState(this.error);
}

class UpdateBookSuccessState extends LibraryStates {}

class UpdateBookErrorState extends LibraryStates {
  final String error;
  UpdateBookErrorState(this.error);
}

class ChangeSelectionListState extends LibraryStates {}

class ChangeBottomNavState extends LibraryStates {}

class CreateBookSuccessState extends LibraryStates {}

class CreateBookErrorState extends LibraryStates {
  final String error;
  CreateBookErrorState(this.error);
}

class ReserveBookSuccessState extends LibraryStates {}

class ReserveBookErrorState extends LibraryStates {
  final String error;
  ReserveBookErrorState(this.error);
}

class DeleteBookSuccessState extends LibraryStates {}

class DeleteBookErrorState extends LibraryStates {
  final String error;
  DeleteBookErrorState(this.error);
}

class GetCategoryLoadingState extends LibraryStates {}

class GetCategorySuccessState extends LibraryStates {}

class GetCategoryErrorState extends LibraryStates {
  final String error;
  GetCategoryErrorState(this.error);
}

class AddFavSuccessState extends LibraryStates {}

class DeleteFavSuccessState extends LibraryStates {}

class AddFavErrorState extends LibraryStates {
  final String error;
  AddFavErrorState(this.error);
}

class BuyFavSuccessState extends LibraryStates {}

class BuyFavErrorState extends LibraryStates {
  final String error;
  BuyFavErrorState(this.error);
}

class GetFavLoadingState extends LibraryStates {}

class GetFavSuccessState extends LibraryStates {}

class GetFavErrorState extends LibraryStates {
  final String error;
  GetFavErrorState(this.error);
}

class GetMyBooksLoadingState extends LibraryStates {}

class GetMyBooksSuccessState extends LibraryStates {}

class GetMyBooksErrorState extends LibraryStates {
  final String error;
  GetMyBooksErrorState(this.error);
}

class GetBooksLoadingState extends LibraryStates {}

class GetBooksSuccessState extends LibraryStates {}

class GetBooksErrorState extends LibraryStates {
  final String error;
  GetBooksErrorState(this.error);
}

class BookImagePickedLoadingState extends LibraryStates {}

class BookImagePickedSuccessState extends LibraryStates {}

class BookImagePickedErrorState extends LibraryStates {
  final String error;
  BookImagePickedErrorState(this.error);
}

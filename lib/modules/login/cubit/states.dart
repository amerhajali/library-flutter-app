abstract class AdminLoginStates {}

class AdminLoginInitialState extends AdminLoginStates {}

class AdminLoginPasswordState extends AdminLoginStates {}

class AdminLoginLoadingState extends AdminLoginStates {}

class AdminLoginSuccessState extends AdminLoginStates {
  final String adminId;

  AdminLoginSuccessState(this.adminId);
}

class LoginSuccessState extends AdminLoginStates {
  final String uid;

  LoginSuccessState(this.uid);
}

class AdminLoginErrorState extends AdminLoginStates {
  final String error;
  AdminLoginErrorState(this.error);
}

class RegisterLoadingState extends AdminLoginStates {}

class RegisterSuccessState extends AdminLoginStates {
  final String uid;

  RegisterSuccessState(this.uid);
}

class RegisterErrorState extends AdminLoginStates {
  final String error;
  RegisterErrorState(this.error);
}

class ChangeModeState extends AdminLoginStates {}

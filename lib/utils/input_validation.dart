String? titleValidator(String? title) {
  if (title!.trim().isEmpty) {
    return 'please enter a title';
  }
  return null;
}

String? priceValidator(String? price) {
  if (price!.trim().isEmpty) {
    return 'Please enter a price !';
  }
  if (double.tryParse(price) == null) {
    return 'Please enter a valid number !';
  }
  if (double.parse(price) <= 0) {
    return 'The price must be > \$0 ';
  }
  return null;
}

String? descriptionValidator(String? desc) {
  if (desc!.trim().isEmpty) {
    return 'Please enter a description ';
  }
  if (desc.trim().length < 10) {
    return 'The description must be at least 10 letters long ';
  }
  return null;
}

String? urlValidator(String? url) {
  if (url!.trim().isEmpty) {
    return 'Please enter a url ';
  }
  return null;
}

String? emailValidator(String? email) {
  final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (email!.trim().isEmpty) {
    return 'please enter an email';
  }
  if (emailRegExp.hasMatch(email)) {
    return null;
  } else {
    return 'Please enter a valid email ex : email@example.com';
  }
}

String? nameVlidator(String? name) {
  final nameRegExp =
      RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
  if (name!.trim().isEmpty) {
    return 'please enter a name';
  }
  if (nameRegExp.hasMatch(name)) {
    return null;
  } else {
    return 'Please enter a valid name';
  }
}

String? passwordValidator(String? password, [int minLength = 6]) {
  if (password == null || password.isEmpty) {
    return 'Please enter a password';
  }

  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  bool hasSpecialCharacters =
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = password.length > minLength;

  if (!hasUppercase) {
    return 'The password must contain an Uper case ex : exAMple12*';
  }
  if (!hasLowercase) {
    return 'The password must contain an lower case ex : exAMple12*';
  }
  if (!hasDigits) {
    return 'The password must contain digits ex : exAMple12*';
  }
  if (!hasSpecialCharacters) {
    return 'The password must contain special characters ex : exAMple12*';
  }
  if (!hasMinLength) {
    return 'The password must be at least 6 characters long ex : exAMple12*';
  }
  return null;
}

String? isIdentical(String? password, String? confirmation) {
  if (confirmation!.isEmpty) {
    return 'Please confirm password';
  }
  if (password!.isEmpty) {
    return 'you must enter a password first the confirm it';
  }
  return password == confirmation
      ? null
      : 'Password and confirmation must be identical';
}

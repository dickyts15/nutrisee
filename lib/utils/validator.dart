class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateUsername({required String? username}) {
    if (username == null) {
      return null;
    }

    if (username.isEmpty) {
      return 'Username can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    RegExp passwordRegExp = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 8) {
      return 'Enter a password with length at least 8 characters';
    } else if (!passwordRegExp.hasMatch(password)) {
      return 'Enter a password with special char';
    }

    return null;
  }

  static String? validateAge({required String? age}) {
    if (age == null) {
      return null;
    }

    if (age.isEmpty) {
      return 'Age can\'t be empty';
    }

    return null;
  }

  static String? validateGender({required String? gender}) {
    if (gender == null) {
      return null;
    }

    if (gender.isEmpty) {
      return 'Gender can\'t be empty';
    }

    return null;
  }

  static String? validateNumber({required String? number}) {
    if (number == null || number.isEmpty) {
      return "Can't be empty";
    }

    final RegExp regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(number)) {
      return "Only numbers are allowed";
    }

    return null;
  }
}

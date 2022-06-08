class Validator {
  static bool isPasswordNotLongEnough(String password) {
    const requiredLength = 6;
    return password.length < requiredLength ? true : false;
  }

  static bool isConfirmationPasswordNotMatch(
      String password, String confirmationPassword) {
    return password != confirmationPassword ? true : false;
  }
}

String authError(String error) {
  if (error.contains('EMAIL_EXISTS')) {
    return 'The email address is already in use by another account.';
  }
  if (error.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
    return 'We have blocked all requests from this device due to unusual activity. Try again later.';
  }
  if (error.contains('EMAIL_NOT_FOUND')) {
    return 'There is no user record corresponding to this identifier. The user may have been deleted.';
  }
  if (error.contains('INVALID_PASSWORD')) {
    return 'The password is invalid';
  }
  if (error.contains('USER_DISABLED')) {
    return 'The user account has been disabled by an administrator.';
  }
  return 'Authentcation failed!, $error';
}

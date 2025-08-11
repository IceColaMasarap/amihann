class AuthHelper {
  static String getErrorMessage(dynamic error) {
    if (error.toString().contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.toString().contains('Email not confirmed')) {
      return 'Please check your email and confirm your account';
    } else if (error.toString().contains('User already registered')) {
      return 'An account with this email already exists';
    } else if (error.toString().contains('Password should be at least')) {
      return 'Password should be at least 6 characters';
    } else if (error.toString().contains('Invalid email')) {
      return 'Please enter a valid email address';
    }
    return 'An error occurred. Please try again.';
  }
}

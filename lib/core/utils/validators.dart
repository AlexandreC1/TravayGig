import '../constants/app_constants.dart';

/// Utility class for form validation
class Validators {
  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanpri antre imel ou';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Tanpri antre yon imel valid';
    }

    return null;
  }

  /// Validate password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanpri antre modpas ou';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Modpas dwe gen omwen ${AppConstants.minPasswordLength} karaktè';
    }

    return null;
  }

  /// Validate required field
  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Tanpri antre $fieldName';
    }
    return null;
  }

  /// Validate gig title
  static String? gigTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanpri antre tit travay la';
    }

    if (value.length > AppConstants.maxTitleLength) {
      return 'Tit la twò long (maksimòm ${AppConstants.maxTitleLength} karaktè)';
    }

    return null;
  }

  /// Validate gig description
  static String? gigDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanpri antre deskripsyon travay la';
    }

    if (value.length > AppConstants.maxDescriptionLength) {
      return 'Deskripsyon an twò long (maksimòm ${AppConstants.maxDescriptionLength} karaktè)';
    }

    return null;
  }

  /// Validate price
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanpri antre pri a';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Tanpri antre yon nimewo valid';
    }

    if (price < AppConstants.minPrice) {
      return 'Pri a dwe omwen ${AppConstants.minPrice} ${AppConstants.currency}';
    }

    if (price > AppConstants.maxPrice) {
      return 'Pri a pa dwe depase ${AppConstants.maxPrice} ${AppConstants.currency}';
    }

    return null;
  }

  /// Validate full name
  static String? fullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanpri antre non konplè ou';
    }

    if (value.length < 2) {
      return 'Non an twò kout';
    }

    return null;
  }
}

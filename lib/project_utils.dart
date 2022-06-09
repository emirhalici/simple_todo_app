import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectUtils {
  static void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 18.sp,
          ),
        ),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  static Widget circularProgressBar(BuildContext context) => Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
}

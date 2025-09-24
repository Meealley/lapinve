// lib/utils/alert_utils.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AlertUtils {
  /// Shows a platform-specific alert dialog
  static Future<void> showPlatformAlert({
    required BuildContext context,
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onActionPressed,
  }) async {
    final theme = Theme.of(context);
    final fontFamily = theme.textTheme.bodyLarge?.fontFamily;

    if (Platform.isIOS) {
      return showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (actionText != null && onActionPressed != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onActionPressed();
                },
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (actionText != null && onActionPressed != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onActionPressed();
                },
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  /// Shows an error alert dialog
  static Future<void> showErrorAlert({
    required BuildContext context,
    required String message,
    String title = 'Error',
  }) async {
    return showPlatformAlert(context: context, title: title, message: message);
  }

  /// Shows a success alert dialog
  static Future<void> showSuccessAlert({
    required BuildContext context,
    required String message,
    String title = 'Success',
  }) async {
    return showPlatformAlert(context: context, title: title, message: message);
  }

  /// Shows a confirmation dialog with Yes/No options
  static Future<bool?> showConfirmationAlert({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final theme = Theme.of(context);
    final fontFamily = theme.textTheme.bodyLarge?.fontFamily;

    if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmText,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(
                confirmText,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class AppUtils {
  PermissionStatus status;

  static Future<bool> getConnectionState() async {
    return await DataConnectionChecker().hasConnection;
  }

  static void showDialog({
    @required BuildContext context,
    @required String title,
    @required String negativeText,
    @required String positiveText,
    @required Function onPositiveButtonPressed,
    Function onNegativeButtonPressed,
    @required String contentText,
    DialogTransitionType type,
  }) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      animationType: type ?? DialogTransitionType.scale,
      duration: Duration(
        milliseconds: 400,
      ),
      builder: (context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          negativeText: negativeText,
          positiveText: (positiveText == '' || positiveText == null)
              ? null
              : positiveText,
          onNegativeClick: onPositiveButtonPressed,
          contentText: contentText,
          onPositiveClick: onNegativeButtonPressed ??
                  () {
                Navigator.of(context).pop();
              },
        );
      },
    );
  }

  static hidwKeyboared(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static showToast({@required msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // true if granted : false if denied
  static Future<bool> checkPermissionState(PermissionGroup permissions) async {
    bool permissionState = false;
    await PermissionHandler().checkPermissionStatus(permissions).then(
          (state) {
        if (state == PermissionStatus.granted) {
          permissionState = true;
        } else {
          permissionState = false;
        }
      },
    );
    return permissionState;
  }

  static void exitFromApp() {
    exit(0);
  }

  // true if granted : false if denied
  static Future<bool> askPhotosPermission() async {
    bool permissionState = false;
    await PermissionHandler().requestPermissions([
      Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos,
    ]).then(
          (Map<PermissionGroup, PermissionStatus> map) {
        if (map[PermissionGroup.storage] == PermissionStatus.granted) {
          permissionState = true;
        } else {
          permissionState = false;
        }
      },
    );

    print('state of permission >>>> $permissionState');
    return permissionState;
  }
}

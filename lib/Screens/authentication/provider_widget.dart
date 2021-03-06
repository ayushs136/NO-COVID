import 'package:flutter/material.dart';
import 'package:helpdesk_shift/screens/authentication/auth_services.dart';

class ProviderWidget extends InheritedWidget {
  final AuthServices auth;

  ProviderWidget({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ProviderWidget of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<ProviderWidget>() as ProviderWidget);
}
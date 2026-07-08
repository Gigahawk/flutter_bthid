import 'package:flutter/material.dart';

class ControllerType {
  const ControllerType({required this.name, required this.icon, required this.widget});

  final String name;
  final IconData icon;
  final Widget widget;

  NavigationDrawerDestination get dest => NavigationDrawerDestination(icon: Icon(icon), label: Text(name));
}
import 'dart:io';

import 'package:flutter/material.dart';


class Failure implements Exception {
  // Use something like "int code;" if you want to translate error messages
  final String message;

  Failure({@required this.message});

  @override
  String toString() => message;

  handleNetworkError(Exception e) {
    if (e is SocketException)
      throw Failure(message: 'no_connection');
    else if (e is HttpException)
      throw Failure(message: 'http_ex');
    else if (e is FormatException)
      throw Failure(message: 'bad_response');
    else if (e is Failure) throw Failure(message: '${e.message}');
  }
}

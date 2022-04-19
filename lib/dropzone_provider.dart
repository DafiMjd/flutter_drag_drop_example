import 'package:flutter/material.dart';

class DropzoneProvider extends ChangeNotifier{
  
  bool _highlight = false;
  get highlight => _highlight;
  set highlight(val) {
    _highlight = val;
    notifyListeners();
  }



  
}
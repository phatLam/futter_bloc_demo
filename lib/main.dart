import 'package:bloc/bloc.dart';
import 'package:demo2/simple_bloc_observer.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';

void main() {
  ///to log transitions and any errors.
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}

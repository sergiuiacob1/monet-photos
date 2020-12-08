import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:monet_photos/app.dart';
import 'package:monet_photos/bloc/simple_bloc_observer.dart';
import 'package:monet_photos/bloc/global_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final GlobalBloc globalBloc = GlobalBloc(prefs);
  Bloc.observer = SimpleBlocObserver(globalBloc);

  runApp(
    BlocProvider.value(
      value: globalBloc,
      child: MyApp(),
    ),
  );
}

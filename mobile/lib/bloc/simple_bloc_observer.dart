import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:monet_photos/bloc/global_bloc.dart';
import 'package:monet_photos/bloc/image_transformer_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  final GlobalBloc globalBloc;

  SimpleBlocObserver(this.globalBloc);

  @override
  void onEvent(Bloc bloc, Object event) {
    // debugPrint("Got event: $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // debugPrint("Transition between states: $transition");
    if (transition.nextState is TransformingFinished)
      globalBloc.increaseNoSuccessfulTransforms();
    super.onTransition(bloc, transition);
  }

  @override
  void onError(dynamic bloc, Object error, StackTrace stackTrace) {
    debugPrint("Bloc error: $error");
    super.onError(bloc, error, stackTrace);
  }
}

import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    // print("Got event: $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // print("Transition between states: $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onError(dynamic bloc, Object error, StackTrace stackTrace) {
    print("Bloc error: $error");
    super.onError(bloc, error, stackTrace);
  }
}

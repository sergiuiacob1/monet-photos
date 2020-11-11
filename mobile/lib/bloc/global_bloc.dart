import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final SharedPreferences prefs;
  GlobalBloc(this.prefs) : super(GlobalInitial());

  @override
  Stream<GlobalState> mapEventToState(
    GlobalEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  void increaseNoSuccessfulTransforms() async {
    // TODO use RW lock
    final current = this.prefs.getInt('no_successful_transforms') ?? 0;
    this.prefs.setInt('no_successful_transforms', current + 1);
  }

  void increaseNoFailedTransforms() async {
    // TODO use RW lock
    final current = this.prefs.getInt('no_failed_transforms') ?? 0;
    this.prefs.setInt('no_failed_transforms', current + 1);
  }

  int get noSuccessfulTransforms =>
      this.prefs.getInt('no_successful_transforms') ?? 0;
  int get noFailedTransforms => this.prefs.getInt('no_failed_transforms') ?? 0;
}

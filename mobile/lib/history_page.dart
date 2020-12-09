import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monet_photos/bloc/global_bloc.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Number of successful transforms: ${_getSuccessfulTransforms(context)}",
            textAlign: TextAlign.center,
          ),
          Text(
            "Number of failed transforms: ${_getFailedTransforms(context)}",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getSuccessfulTransforms(BuildContext context) {
    final GlobalBloc bloc = BlocProvider.of<GlobalBloc>(context);
    return bloc.noSuccessfulTransforms;
  }

  int _getFailedTransforms(BuildContext context) {
    final GlobalBloc bloc = BlocProvider.of<GlobalBloc>(context);
    return bloc.noFailedTransforms;
  }
}

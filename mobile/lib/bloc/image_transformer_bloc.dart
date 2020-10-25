import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'image_transformer_event.dart';
part 'image_transformer_state.dart';

class ImageTransformerBloc
    extends Bloc<ImageTransformerEvent, ImageTransformerState> {
  ImageTransformerBloc() : super(WaitingForImage());

  @override
  Stream<ImageTransformerState> mapEventToState(
    ImageTransformerEvent event,
  ) async* {
    if (event is ChoosingImage) {
      yield WaitingForImage();
    } else if (event is ImageChosen) {
      if (event.img != null)
        yield WaitingForTransformRequest(event.img);
      else
        yield WaitingForImage();
    } else if (event is ImageChoosingFailed) {
      yield WaitingForImage();
    }
  }
}

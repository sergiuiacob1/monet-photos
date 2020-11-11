import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:monet_photos/bloc/api.dart';

part 'image_transformer_event.dart';
part 'image_transformer_state.dart';

class ImageTransformerBloc
    extends Bloc<ImageTransformerEvent, ImageTransformerState> {
  ImageTransformerBloc() : super(WaitingForImage());

  @override
  Stream<ImageTransformerState> mapEventToState(
    ImageTransformerEvent event,
  ) async* {
    if (event is ResetProcess) {
      yield WaitingForImage();
    }
    if (event is ChoosingImage) {
      yield WaitingForImage();
    } else if (event is ImageChosen) {
      if (event.img != null)
        yield WaitingForTransformRequest(event.img);
      else
        yield WaitingForImage();
    } else if (event is ImageChoosingFailed) {
      yield WaitingForImage();
    } else if (event is TransformRequested) {
      yield* _mapTransformImage(event.img);
    }
  }

  Stream<ImageTransformerState> _mapTransformImage(final img) async* {
    assert(this.state is WaitingForTransformRequest);
    await for (var data in API.post(img)) {
      switch (data[0]) {
        case APIStatus.sendingRequest:
          yield TransformingImage(img, TransformingImageState.sendingToServer);
          break;
        case APIStatus.waiting:
          yield TransformingImage(img, TransformingImageState.waitingResponse);
          break;
        case APIStatus.success:
          yield TransformingFinished(data[1]);
          break;
        case APIStatus.failed:
          yield TransformingFailed(data[1]);
          break;
      }
    }
  }
}

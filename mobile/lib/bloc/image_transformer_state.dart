part of 'image_transformer_bloc.dart';

@immutable
abstract class ImageTransformerState {}

class WaitingForImage extends ImageTransformerState {}

class WaitingForTransformRequest extends ImageTransformerState {
  final img;
  WaitingForTransformRequest(this.img);
}

enum ImageTransformerWorkingState {
  sendingToServer,
  sentToServer,
  waitingResponse,
  setResponse
}

class ImageTransformerWorking extends ImageTransformerState {}

class ImageTransformerFinished extends ImageTransformerState {}

part of 'image_transformer_bloc.dart';

@immutable
abstract class ImageTransformerState {
  final img;
  ImageTransformerState(this.img);
}

class WaitingForImage extends ImageTransformerState {
  WaitingForImage() : super(null);
}

class WaitingForTransformRequest extends ImageTransformerState {
  WaitingForTransformRequest(var img) : super(img);
}

enum TransformingImageState {
  sendingToServer,
  waitingResponse,
}

class TransformingImage extends ImageTransformerState {
  final TransformingImageState status;
  TransformingImage(var img, this.status) : super(img);
}

class TransformingFinished extends ImageTransformerState {
  TransformingFinished(img) : super(img);
}

class TransformingFailed extends ImageTransformerState {
  final String reason;
  TransformingFailed(this.reason) : super(null);
}

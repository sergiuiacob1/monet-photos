part of 'image_transformer_bloc.dart';

@immutable
abstract class ImageTransformerEvent {}

class ResetProcess extends ImageTransformerEvent {}

class ChoosingImage extends ImageTransformerEvent {}

class ImageChosen extends ImageTransformerEvent {
  final img;
  ImageChosen(this.img);
}

class ImageChoosingFailed extends ImageTransformerEvent {
  final String reason;
  ImageChoosingFailed(this.reason);
}

class TransformRequested extends ImageTransformerEvent {
  final img;
  TransformRequested(this.img);
}

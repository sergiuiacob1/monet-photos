import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:monet_photos/bloc/image_transformer_bloc.dart';

class ImageTransformer extends StatelessWidget {
  final bloc = ImageTransformerBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<ImageTransformerBloc, ImageTransformerState>(
        builder: (context, state) => Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getTextByState(state),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              ImageViewer(state),
              Actions(state),
            ],
          ),
        ),
      ),
    );
  }

  String _getTextByState(ImageTransformerState state) {
    if (state is WaitingForImage) {
      return "Monet - choose your image";
    } else if (state is WaitingForTransformRequest) {
      return "Monet – transform the image";
    } else if (state is TransformingImage) {
      return "Monet – transforming image";
    } else if (state is TransformingFinished) {
      return "Monet – transform successful";
    }

    return "Unknown state";
  }
}

class ImageViewer extends StatelessWidget {
  final state;
  ImageViewer(this.state);

  Widget build(BuildContext context) {
    return Expanded(
      child: _getChild(),
    );
  }

  Widget _getChild() {
    if (state is WaitingForTransformRequest)
      return FutureBuilder<Uint8List>(
        builder: (context, imgBytes) {
          if (imgBytes.hasData) {
            if (imgBytes.data == null) {
              return Text("NO DATA RECEIVED");
            }
            return Image.memory(imgBytes.data);
          }
          return CircularProgressIndicator();
        },
        future: state.img.readAsBytes(),
        initialData: null,
      );

    if (state is TransformingImage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(state.status.toString()),
          Divider(),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }
    if (state is TransformingFinished)
      return FutureBuilder<Uint8List>(
        builder: (context, imgBytes) {
          if (imgBytes.hasData) {
            if (imgBytes.data == null) {
              return Text("NO DATA RECEIVED");
            }
            return Image.memory(imgBytes.data);
          }
          return CircularProgressIndicator();
        },
        // state has the byte images
        future: state.img,
        initialData: null,
      );

    if (state is TransformingFailed)
      return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Center(
          child: Text("Transformation failed: ${state.reason}"),
        ),
      );

    return Container(
      decoration: BoxDecoration(border: Border.all()),
    );
  }
}

class Actions extends StatelessWidget {
  final state;
  final picker = ImagePicker();

  Actions(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RaisedButton(
          onPressed: () => _chooseImage(context),
          child: Text("Choose image"),
        ),
        RaisedButton(
          onPressed: (state is WaitingForTransformRequest)
              ? () => _transformImage(context)
              : null,
          child: Text("Transform image"),
        ),
      ],
    );
  }

  void _transformImage(BuildContext context) async {
    final ImageTransformerBloc bloc =
        BlocProvider.of<ImageTransformerBloc>(context);
    assert(bloc.state is WaitingForTransformRequest);
    bloc.add(TransformRequested(bloc.state.img));
  }

  void _chooseImage(BuildContext context) async {
    final ImageTransformerBloc bloc =
        BlocProvider.of<ImageTransformerBloc>(context);
    bloc.add(ChoosingImage());

    bool permissionGranted = await _isPermissionGranted();
    if (permissionGranted) {
      try {
        final img = await picker.getImage(source: ImageSource.gallery);
        bloc.add(ImageChosen(img));
      } catch (e) {
        print("Error: $e");
      }
    } else {
      bloc.add(ImageChoosingFailed("Storage permission not granted"));
    }
  }

  Future<bool> _isPermissionGranted([bool ask = true]) async {
    Map<Permission, PermissionStatus> permissionsGranted = await [
      Permission.photos,
    ].request();

    if (permissionsGranted[Permission.photos].isGranted) {
      return true;
    }

    if (ask) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
      ].request();
      return statuses[Permission.photos].isGranted;
    }

    return false;
  }
}

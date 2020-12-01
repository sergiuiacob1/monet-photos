import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monet_photos/waiting_for_image.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:monet_photos/bloc/image_transformer_bloc.dart';

import 'edit_image_screen.dart';

class ImageTransformer extends StatefulWidget {
  @override
  _ImageTransformerState createState() => _ImageTransformerState();
}

class _ImageTransformerState extends State<ImageTransformer> {
  final bloc = ImageTransformerBloc();

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<ImageTransformerBloc, ImageTransformerState>(
        builder: (context, state) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getWidgetByState(state),
              Actions(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWidgetByState(ImageTransformerState state) {
    if (state is WaitingForImage) return WaitingForImageWidget();
    return ImageViewer(state);
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

class EditImageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: () => _editImage(context),
        child: Text("Edit image"),
      );

  void _editImage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditImageScreen()));
  }
}

class ChooseImageButton extends StatelessWidget {
  final state;
  final picker = ImagePicker();

  ChooseImageButton(this.state);

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: () => _chooseImage(context),
        child: Text(_getTextByState()),
      );

  String _getTextByState() {
    print("Got state: $state");
    if (state is TransformingFinished) return "Transform again";
    return "Choose image";
  }

// TODO delete
  void _chooseImage(BuildContext context) async {
    // ignore: close_sinks
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

class Actions extends StatelessWidget {
  final state;

  Actions(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ChooseImageButton(state),
        state is TransformingFinished
            ? EditImageButton()
            : RaisedButton(
                onPressed: (state is WaitingForTransformRequest)
                    ? () => _transformImage(context)
                    : null,
                child: Text("Transform image"),
              ),
        if (state is TransformingFinished) ShareButton(),
      ],
    );
  }

  void _transformImage(BuildContext context) async {
    // ignore: close_sinks
    final ImageTransformerBloc bloc =
        BlocProvider.of<ImageTransformerBloc>(context);
    assert(bloc.state is WaitingForTransformRequest);
    bloc.add(TransformRequested(bloc.state.img));
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: null,
      child: Text("Share"),
    );
  }
}

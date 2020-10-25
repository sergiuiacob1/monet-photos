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
              const Text(
                "Monet",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
}

class ImageViewer extends StatelessWidget {
  final state;
  ImageViewer(this.state);

  Widget build(BuildContext context) {
    return Expanded(
      child: (state is WaitingForTransformRequest)
          ? FutureBuilder<Uint8List>(
              builder: (context, imgBytes) {
                if (imgBytes.hasData) {
                  return Image.memory(imgBytes.data);
                }
                return Expanded(child: CircularProgressIndicator());
              },
              future: state.img.readAsBytes(),
              initialData: null,
            )
          : Container(
              decoration: BoxDecoration(border: Border.all()),
            ),
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
              ? () => _chooseImage(context)
              : null,
          child: Text("Transform image"),
        ),
      ],
    );
  }

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

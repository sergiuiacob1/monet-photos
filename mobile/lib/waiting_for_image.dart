import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monet_photos/bloc/image_transformer_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class WaitingForImageWidget extends StatelessWidget {
  const WaitingForImageWidget();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/monet_sample.jpeg"), fit: BoxFit.fill),
        ),
        child: ClipRRect(
          // make sure we apply clip it properly
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ExplanatoryContainer(),
                const Padding(padding: EdgeInsets.only(top: 32.0)),
                const UploadImageWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExplanatoryContainer extends StatelessWidget {
  const ExplanatoryContainer();
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: const Text(
          "Choose an image and transform it in Monet's style",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
}

class _Button extends StatelessWidget {
  final IconData icon;
  final Function callback;
  final String text;

  _Button(this.icon, this.text, this.callback);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Icon(
            this.icon,
            size: 64.0,
            color: Colors.white,
          ),
          onTap: this.callback,
        ),
        Text(
          this.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Button(Icons.camera, "Use camera",
            () => _chooseImage(context, ImageSource.camera)),
        _Button(Icons.image, "Use gallery",
            () => _chooseImage(context, ImageSource.gallery)),
      ],
    );
  }

  void _chooseImage(BuildContext context, ImageSource source) async {
    // ignore: close_sinks
    final ImageTransformerBloc bloc =
        BlocProvider.of<ImageTransformerBloc>(context);
    final picker = ImagePicker();
    bloc.add(ChoosingImage());

    bool permissionGranted = await _isPermissionGranted(source);
    if (permissionGranted) {
      try {
        final img = await picker.getImage(source: source);
        bloc.add(ImageChosen(img));
      } catch (e) {
        debugPrint("Error: $e");
      }
    } else {
      bloc.add(ImageChoosingFailed(
          "Storage permission not granted for ${source.toString()}"));
    }
  }

  Future<bool> _isPermissionGranted(ImageSource source,
      [bool ask = true]) async {
    Permission toAsk;
    if (source == ImageSource.camera)
      toAsk = Permission.camera;
    else
      toAsk = Permission.photos;

    Map<Permission, PermissionStatus> permissionsGranted =
        await [toAsk].request();

    if (permissionsGranted[toAsk].isGranted) {
      return true;
    }

    if (ask) {
      Map<Permission, PermissionStatus> statuses = await [toAsk].request();
      return statuses[toAsk].isGranted;
    }

    return false;
  }
}

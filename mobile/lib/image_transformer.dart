import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

import 'package:monet_photos/bloc/image_transformer_bloc.dart';
import 'package:monet_photos/waiting_for_image.dart';
import 'package:monet_photos/edit_image_screen.dart';

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

class TransformAgainButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: () {
          // ignore: close_sinks
          final ImageTransformerBloc bloc =
              BlocProvider.of<ImageTransformerBloc>(context);
          bloc.add(ResetProcess());
        },
        child: Text("Transform another"),
      );
}

class Actions extends StatelessWidget {
  final state;

  Actions(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (state is TransformingFinished) TransformAgainButton(),
        if (state is TransformingFinished) EditImageButton(),
        if (state is WaitingForTransformRequest)
          RaisedButton(
            onPressed: (state is WaitingForTransformRequest)
                ? () => _transformImage(context)
                : null,
            child: Text("Transform image"),
          ),
        if (state is TransformingFinished) ShareButton(state.img),
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
  final Future<Uint8List> img;
  const ShareButton(this.img);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => _shareImage(context),
      child: Text("Share"),
    );
  }

  void _shareImage(BuildContext context) async {
    final Uint8List data = await this.img;
    // TODO this is not supported in iOS
    try {
      final directory = (await getExternalStorageDirectory()).path;
      // TODO I should know the extension
      File imgFile = new File('$directory/share.jpeg');
      imgFile.writeAsBytesSync(data);

      Share.shareFiles(
        [imgFile.path],
        subject: "Monet photo",
        text: "Check out my picture painted in Monet's style!",
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

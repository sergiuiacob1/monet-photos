import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

enum APIStatus {
  sendingRequest,
  waiting,
  success,
  failed,
}

class API {
  static final _url = "https://aset-monet-photos.ew.r.appspot.com";

  static Stream<dynamic> post(PickedFile img) async* {
    yield [APIStatus.sendingRequest, null];
    final imgBytes = await img.readAsBytes();
    try {
      final client = http.Client();
      var request = http.MultipartRequest('POST', Uri.parse(API._url));
      request.files.add(
        http.MultipartFile.fromBytes('file', imgBytes, filename: img.path),
      );

      final response = client.send(request);
      yield [APIStatus.waiting, null];

      http.StreamedResponse finishedResponse = await response;
      Future<Uint8List> bytes = finishedResponse.stream.toBytes();

      if (finishedResponse.statusCode == 200)
        yield [APIStatus.success, bytes];
      else
        yield [APIStatus.failed, finishedResponse.statusCode];
    } catch (e) {
      print(e);
      yield [APIStatus.failed, e.toString()];
    }
  }
}

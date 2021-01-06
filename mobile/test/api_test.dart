// Tests that the API from GCP is reachable
import 'package:image_picker/image_picker.dart';
import 'package:monet_photos/bloc/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // PickedFile file = PickedFile("assets/monet_sample.jpeg");
  testWidgets("Test communication with the API", (WidgetTester tester) async {
    // Stream res = API.post(file);

    bool executedSuccessfully = false;
    await Future.delayed(Duration(seconds: 3));
    // await for (var data in res) {
    //   if (data[0] == APIStatus.success) executedSuccessfully = true;
    //   print("Received ${data[0]}");
    // }

    assert(executedSuccessfully == true);
  });
}

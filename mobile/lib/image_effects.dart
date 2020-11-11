class BaseDecorator {
  var image;
}

class BrightnessDecorator extends BaseDecorator {
  int brightness;

  BrightnessDecorator(image) {
    _calculateInitialBrightness(image);
  }

  void _calculateInitialBrightness(var image) {
    this.brightness = 50;
  }

  void modifyBrightness(int amount) {}
}

class ContrastDecorator extends BaseDecorator {
  int contrast;

  ContrastDecorator(image) {
    _calculateInitialContrast(image);
  }

  void _calculateInitialContrast(var image) {
    this.contrast = 50;
  }

  void modifyContrast(int amount) {}
}

// ...

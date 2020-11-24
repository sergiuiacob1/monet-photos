class MementoManager {
  void saveHistory() {}
  void loadHistory() {}
}

class Memento {
  void saveToMemory() {}
}

class ImageSnapshot extends Memento {
  var transformedImg;
  var effectsApplied;
}

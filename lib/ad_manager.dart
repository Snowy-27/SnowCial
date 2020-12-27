import 'dart:io';

class AdManager {
  String getappId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-1380656527637231~4935197524";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  String getbannerAdUnitId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-1380656527637231/1560905200";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

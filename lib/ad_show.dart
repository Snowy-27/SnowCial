import 'package:authsnow/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Add {
  var ams = AdManager();
  BannerAd myBanner;
  bool showa = true;
  void show() {
    FirebaseAdMob.instance.initialize(appId: ams.getappId());
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-1380656527637231/1560905200',
      size: AdSize.banner,
      listener: (MobileAdEvent event) {},
    );

    myBanner
      ..load()
      ..show(
        anchorOffset: 52,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
  }

  void dispose() {
    myBanner.dispose();
  }
}

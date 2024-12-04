import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

String user = "admin";
String password = "admin1234";
String camIp = "193.168.3.3";
//todo: stream the rtsp video
// String rtspUrl =
//     "rtsp://$user:$password@$camIp:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif";

String rtspUrl =
    "rtsp://admin:admin1234@193.168.3.3:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif";

// String rtspUrl = "https://www.youtube.com/watch?v=zDhZgtZ9RNU";

String trtspUrl =
    "https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4";

class IpCamAddress extends StatefulWidget {
  const IpCamAddress({super.key});

  @override
  State<IpCamAddress> createState() => _IpCamAddressState();
}

class _IpCamAddressState extends State<IpCamAddress> {
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  late final tplayer = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final tcontroller = VideoController(tplayer);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(rtspUrl));
    tplayer.open(Media(trtspUrl));
    print("loading: $rtspUrl");
  }

  @override
  void dispose() {
    player.dispose();
    tplayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          child: Video(controller: controller),
        ),
        const SizedBox(height: 100),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          child: Video(controller: tcontroller),
        ),
      ],
    );
  }
}

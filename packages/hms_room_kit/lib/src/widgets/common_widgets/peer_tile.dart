// Package imports
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
// Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/degrade_tile.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/video_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_mute_status.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/brb_tag.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/hand_raise.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/local_peer_more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/name_and_network.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/rtc_stats_view.dart';
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/screenshare_tile.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///This widget is used to render the peer tile
///It contains following parameters
///[scaleType] is used to set the scale type of the video view
///[islongPressEnabled] is used to enable or disable the long press on the video view
///[avatarRadius] is used to set the radius of the avatar
///[avatarTitleFontSize] is used to set the font size of the avatar title
///[avatarTitleTextLineHeight] is used to set the line height of the avatar title
///[PeerTile] is a stateful widget because it uses [FocusDetector]
class PeerTile extends StatefulWidget {
  final ScaleType scaleType;
  final bool islongPressEnabled;
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;
  final HMSTextureViewController? videoViewController;
  final bool isFiveLayout;
  final int index;
  const PeerTile({
    Key? key,
    this.scaleType = ScaleType.SCALE_ASPECT_FILL,
    this.islongPressEnabled = true,
    this.avatarRadius = 34,
    this.avatarTitleFontSize = 34,
    this.avatarTitleTextLineHeight = 40,
    this.videoViewController,
    this.isFiveLayout = false,
    required this.index,
  }) : super(key: key);

  @override
  State<PeerTile> createState() => _PeerTileState();
}

class _PeerTileState extends State<PeerTile> {
  String name = "";
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "fl_${context.read<PeerTrackNode>().peer.name}_video_tile",
      child: FocusDetector(
        onFocusLost: () {
          if (mounted) {
            Provider.of<PeerTrackNode>(context, listen: false)
                .setOffScreenStatus(true);
          }
        },
        onFocusGained: () {
          Provider.of<PeerTrackNode>(context, listen: false)
              .setOffScreenStatus(false);
          if (context.read<PeerTrackNode>().track != null) {
            log("HMSVideoViewController add video track ${context.read<PeerTrackNode>().peer.name} trackType: ${context.read<PeerTrackNode>().track?.source}");
            widget.videoViewController
                ?.addTrack(track: context.read<PeerTrackNode>().track!);
          }
        },
        child: Builder(
          builder: (context) {
            return context.read<PeerTrackNode>().uid.contains("mainVideo")
                ? Container(
                    key: key,
                    decoration: BoxDecoration(
                      color: HMSThemeColors.backgroundDefault,
                    ),
                    child: Semantics(
                      label:
                          "fl_${context.read<PeerTrackNode>().peer.name}_video_on",
                      child: Stack(
                        children: [
                          ///ClipRRect is used to round the video edges
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: VideoView(
                              uid: context.read<PeerTrackNode>().uid,
                              scaleType: widget.scaleType,
                              avatarTitleFontSize: widget.avatarTitleFontSize,
                              avatarRadius: widget.avatarRadius,
                              avatarTitleTextLineHeight:
                                  widget.avatarTitleTextLineHeight,
                              videoViewController: widget.videoViewController,
                            ),
                          ),
                          // Removed nested LayoutBuilder to prevent layout issues
                          Semantics(
                            label:
                                "fl_${context.read<PeerTrackNode>().peer.name}_degraded_tile",
                            child: DegradeTile(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width,
                                maxHeight: MediaQuery.of(context).size.height,
                              ),
                            ),
                          ),
                          Positioned(
                              top: widget.isFiveLayout ? 5 : null,
                              bottom: widget.isFiveLayout ? null : 5,
                              left: 5,
                              child: NameAndNetwork(
                                  maxWidth: MediaQuery.of(context)
                                      .size
                                      .width)), //bottom left
                          Positioned(
                              top: widget.isFiveLayout ? 40 : null,
                              bottom: widget.isFiveLayout ? null : 40,
                              left: 5,
                              child: const HandRaise()), //top left
                          Positioned(
                              top: 5,
                              left: 5,
                              child: const BRBTag()), //top left
                          Positioned(
                              top: 5,
                              right: 5,
                              child: const AudioMuteStatus()), //top right

                          //index == 0 then bottom left

                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: context.read<PeerTrackNode>().peer.isLocal
                                ? const LocalPeerMoreOption(
                                    isInsetTile: false,
                                  )
                                : const MoreOption(),
                          ), //bottom right
                          Semantics(
                            label: "fl_stats_on_tile",
                            child: RTCStatsView(
                                isLocal:
                                    context.read<PeerTrackNode>().peer.isLocal),
                          )
                        ],
                      ),
                    ),
                  )
                : Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_screen_share_tile",
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: HMSThemeColors.surfaceDim, width: 1.0),
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        key: key,
                        child: const ScreenshareTile()),
                  );
          },
        ),
      ),
    );
  }
}

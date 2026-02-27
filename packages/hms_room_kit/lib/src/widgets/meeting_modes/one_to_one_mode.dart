///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/custom_one_to_one_grid.dart';

///[OneToOneMode] is used to render the meeting screen
///This component now simply delegates to CustomOneToOneGrid since we're removing inset tile behavior
class OneToOneMode extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;
  final BuildContext context;
  final int screenShareCount;
  final double bottomMargin;
  const OneToOneMode(
      {Key? key,
      required this.peerTracks,
      required this.context,
      required this.screenShareCount,
      this.bottomMargin = 272})
      : super(key: key);

  @override
  State<OneToOneMode> createState() => _OneToOneModeState();
}

class _OneToOneModeState extends State<OneToOneMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomOneToOneGrid(
          isLocalInsetPresent: false,
          peerTracks: widget.peerTracks,
        ),
      ),
    );
  }
}

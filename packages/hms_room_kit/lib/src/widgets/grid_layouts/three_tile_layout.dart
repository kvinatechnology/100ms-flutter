///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders three tiles on a page
///The three tiles are rendered in a 2x2 grid with one tile on top and two on bottom
///The tiles look like this
/// ┌───────┐
/// │   0   │
/// ├───┬───┤
/// │ 1 │ 2 │
/// └───┴───┘
class ThreeTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const ThreeTileLayout({
    super.key,
    required this.peerTracks,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    ///Here we render two rows
    ///The first row contains the tile with index [startIndex]
    ///The second row contains two tiles with indices [startIndex+1] and [startIndex+2]
    return Column(
      children: [
        Expanded(
          child: ListenablePeerWidget(
            index: startIndex,
            peerTracks: peerTracks,
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ListenablePeerWidget(
                  index: startIndex + 1,
                  peerTracks: peerTracks,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: ListenablePeerWidget(
                  index: startIndex + 2,
                  peerTracks: peerTracks,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

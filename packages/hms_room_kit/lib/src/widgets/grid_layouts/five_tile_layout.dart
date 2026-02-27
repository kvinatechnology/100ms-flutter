///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders five tiles on a page
///The five tiles are rendered in a 2x2 grid with fifth tile at the bottom center in a circular shape
///The tiles look like this
/// ╔═══════╦═══════╗
/// ║   0   ║   1   ║
/// ╠═══════╬═══════╣
/// ║   2   ║   3   ║
/// ╠═══════╩═══════╣
/// ║  ╭─────────╮  ║
/// ║  │    4    │  ║
/// ║  ╰─────────╯  ║
/// ╚═══════════════╝
class FiveTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const FiveTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    ///Here we render two rows with two tiles in each row and last a center circular tile
    ///The first row contains the tiles with index [startIndex] and [startIndex+1]
    ///The second row contains the tiles with index [startIndex+2] and [startIndex+3]
    ///The third row contains the center circular tile with index [startIndex+4]
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(children: [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: ListenablePeerWidget(
                      alignFiveLayout: true,
                      index: startIndex + 1,
                      peerTracks: peerTracks),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: ListenablePeerWidget(
                      alignFiveLayout: true,
                      index: startIndex + 2,
                      peerTracks: peerTracks),
                ),
                SizedBox(
                  width: 4,
                ),
              ]),
            ),
            SizedBox(
              height: 4,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ListenablePeerWidget(
                    index: startIndex, peerTracks: peerTracks),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Expanded(
              child: Row(children: [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: ListenablePeerWidget(
                      index: startIndex + 3, peerTracks: peerTracks),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: ListenablePeerWidget(
                      index: startIndex + 4, peerTracks: peerTracks),
                ),
                SizedBox(
                  width: 4,
                ),
              ]),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
        // Container(
        //     width: MediaQuery.of(context).size.width / 2,
        //     height: MediaQuery.of(context).size.height / 3,
        //     clipBehavior: Clip.hardEdge,
        //     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
        //     child: ListenablePeerWidget(index: startIndex, peerTracks: peerTracks))
      ],
    );
  }
}

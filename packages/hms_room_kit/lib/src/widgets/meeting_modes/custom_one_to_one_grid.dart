///Package imports
library;

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/grid_layout.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/screen_share_grid_layout.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_screenshare_store.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///This widget renders the grid view of the meeting screen
///The grid view is rendered based on the number of peers in the meeting
///The grid view is rendered using the [PageView] widget
class CustomOneToOneGrid extends StatefulWidget {
  final bool isLocalInsetPresent;
  final List<PeerTrackNode>? peerTracks;
  const CustomOneToOneGrid(
      {super.key, this.isLocalInsetPresent = false, this.peerTracks});

  @override
  State<CustomOneToOneGrid> createState() => _CustomOneToOneGridState();
}

class _CustomOneToOneGridState extends State<CustomOneToOneGrid> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    ///The grid view is rendered using the [PageView] widget
    ///The number of pages in the [PageView] is equal to [numberOfPeers/6 + (if number of peers is not divisible by 6 then we add 1 else we add 0)]
    return Selector<
            MeetingStore,
            Tuple5<List<PeerTrackNode>, int, PeerTrackNode, int,
                HMSWhiteboardModel?>>(
        selector: (_, meetingStore) => Tuple5(
            meetingStore.peerTracks,
            meetingStore.peerTracks.length,
            meetingStore.peerTracks[0],
            meetingStore.screenShareCount,
            meetingStore.whiteboardModel),
        builder: (_, data, __) {
          int numberOfPeers = data.item2;
          int pageCount =
              (numberOfPeers ~/ 6) + (numberOfPeers % 6 == 0 ? 0 : 1);

          var screenshareStore = WhiteboardScreenshareStore(
              meetingStore: context.read<MeetingStore>());

          ///If the remote peer is sharing screen then we render the [ScreenshareGridLayout]
          ///Else we render the normal layout
          return data.item4 > 0 || data.item5 != null
              ? ChangeNotifierProvider.value(
                  value: screenshareStore,
                  child: ScreenshareGridLayout(
                    peerTracks: data.item1,
                    screenshareCount: data.item4,
                    whiteboardModel: data.item5,
                  ),
                )
              :

              ///If no screen is being shared we render the normal layout
              Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                          physics: const PageScrollPhysics(),
                          controller: controller,
                          itemCount: pageCount,
                          onPageChanged: (newPage) {
                            context
                                .read<MeetingStore>()
                                .setCurrentPage(newPage);
                          },
                          itemBuilder: (context, index) => GridLayout(
                              numberOfTiles: numberOfPeers,
                              index: index,
                              peerTracks: data.item1)),
                    ),

                    ///This renders the dots at the bottom of the grid view
                    ///This is only rendered if the number of pages is greater than 1
                    ///The number of dots is equal to [numberOfPeers/6 + (if number of peers is not divisible by 6 then we add 1 else we add 0)]
                    ///The active dot is the current page
                    ///The inactive dots are the pages other than the current page
                    if (pageCount > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Selector<MeetingStore, int>(
                            selector: (_, meetingStore) =>
                                meetingStore.currentPage,
                            builder: (_, currentPage, __) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DotsIndicator(
                                  dotsCount: pageCount,
                                  position: currentPage > pageCount
                                      ? 0.0
                                      : currentPage.toDouble(),
                                  decorator: DotsDecorator(
                                      activeColor:
                                          HMSThemeColors.onSurfaceHighEmphasis,
                                      color:
                                          HMSThemeColors.onSurfaceLowEmphasis),
                                ),
                              );
                            }),
                      )
                  ],
                );
        });
  }
}

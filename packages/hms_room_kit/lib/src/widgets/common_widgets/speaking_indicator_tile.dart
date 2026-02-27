// Package imports
import 'package:flutter/material.dart';
// Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/peer_tile.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

/// A widget that wraps [PeerTile] and adds a glowing border effect when the peer is speaking
class SpeakingIndicatorTile extends StatefulWidget {
  final ScaleType scaleType;
  final bool islongPressEnabled;
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;
  final HMSTextureViewController? videoViewController;
  final bool isFiveLayout;
  final int index;

  const SpeakingIndicatorTile({
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
  State<SpeakingIndicatorTile> createState() => _SpeakingIndicatorTileState();
}

class _SpeakingIndicatorTileState extends State<SpeakingIndicatorTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, int>(
      selector: (_, peerTrackNode) => peerTrackNode.audioLevel,
      builder: (context, audioLevel, child) {
        final isSpeaking = audioLevel > 10; // Threshold for speaking detection

        if (isSpeaking && !_animationController.isAnimating) {
          _animationController.forward();
        } else if (!isSpeaking && _animationController.isCompleted) {
          _animationController.reverse();
        }

        return AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: _glowAnimation.value > 0
                    ? [
                        BoxShadow(
                          color: HMSThemeColors.primaryDefault
                              .withAlpha((200 * _glowAnimation.value).toInt()),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ]
                    : null,
              ),
              child: PeerTile(
                scaleType: widget.scaleType,
                islongPressEnabled: widget.islongPressEnabled,
                avatarRadius: widget.avatarRadius,
                avatarTitleFontSize: widget.avatarTitleFontSize,
                avatarTitleTextLineHeight: widget.avatarTitleTextLineHeight,
                videoViewController: widget.videoViewController,
                isFiveLayout: widget.isFiveLayout,
                index: widget.index,
              ),
            );
          },
        );
      },
    );
  }
}

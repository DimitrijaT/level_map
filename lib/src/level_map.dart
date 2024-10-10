import 'package:flutter/material.dart';
import 'package:level_map/src/model/images_to_paint.dart';
import 'package:level_map/src/model/level_map_params.dart';
import 'package:level_map/src/model/pseudo_random_table.dart';
import 'package:level_map/src/paint/level_map_painter.dart';
import 'package:level_map/src/utils/load_ui_image_to_draw.dart';
import 'package:level_map/src/utils/scroll_behaviour.dart';

class LevelMap extends StatelessWidget {
  final LevelMapParams levelMapParams;
  final Color backgroundColor;

  /// If set to false, scroll starts from the bottom end (level 1).
  final bool scrollToCurrentLevel;

  final int extraSpaceOnTop;

  final int staticSeed;

  final bool isRandom;

  const LevelMap({
    Key? key,
    required this.levelMapParams,
    this.backgroundColor = Colors.transparent,
    this.scrollToCurrentLevel = true,
    this.extraSpaceOnTop = 0,
    this.isRandom = true,
    this.staticSeed = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ScrollConfiguration(
        behavior: const MyBehavior(),
        child: SingleChildScrollView(
          controller: ScrollController(
              initialScrollOffset: (((scrollToCurrentLevel
                          ? (levelMapParams.levelCount -
                              levelMapParams.currentLevel +
                              2)
                          : levelMapParams.levelCount)) *
                      levelMapParams.levelHeight) -
                  constraints.maxHeight),
          // physics: FixedExtentScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                child: Container(
                  color: backgroundColor,
                ),
                height: extraSpaceOnTop.toDouble(),
              ),
              ColoredBox(
                color: backgroundColor,
                child: FutureBuilder<ImagesToPaint?>(
                  future: loadImagesToPaint(
                      levelMapParams,
                      levelMapParams.levelCount,
                      levelMapParams.levelHeight,
                      constraints.maxWidth,
                      isRandom,
                      PseudoRandomTable.hardcoded(staticSeed)),
                  builder: (context, snapshot) {
                    return CustomPaint(
                      size: Size(
                          constraints.maxWidth,
                          levelMapParams.levelCount *
                              levelMapParams.levelHeight),
                      painter: LevelMapPainter(
                          params: levelMapParams, imagesToPaint: snapshot.data),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

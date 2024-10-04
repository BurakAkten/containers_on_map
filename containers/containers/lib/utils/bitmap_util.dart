import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

class BitmapUtil {
  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(String assetName, [Size size = const Size(15, 30)]) async {
    ///https://medium.com/@m1nori/marker-icon-from-svg-image-flutter-2024-875d9bec69b9
    final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

    double devicePixelRatio = ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    int width = (size.width * devicePixelRatio).toInt();
    int height = (size.height * devicePixelRatio).toInt();

    final scaleFactor = min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = ui.PictureRecorder();

    ui.Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final rasterPicture = recorder.endRecording();

    final image = rasterPicture.toImageSync(width, height);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    return BitmapDescriptor.bytes(bytes.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> getClusterMarkerCanvas(int? count, Color color, [Size size = const Size(40, 40)]) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;

    canvas.drawRect(ui.Rect.fromLTRB(0, 0, size.width, size.height), paint..color = color.withOpacity(0.5));
    canvas.drawRect(ui.Rect.fromLTRB(size.width / 10, size.height / 10, size.width - (size.width / 10), size.height - (size.height / 10)), paint);

    TextPainter textPainter = TextPainter(
      text: TextSpan(text: "$count", style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    Offset offset = Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2);

    textPainter.paint(canvas, offset);

    final img = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());

    final data = await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    return BitmapDescriptor.bytes(data.buffer.asUint8List());
  }
}

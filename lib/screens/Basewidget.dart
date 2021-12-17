import 'package:flutter/widgets.dart';

abstract class Basewidget {
  void resize(Size size);
  void render(Canvas canvas);
  void update();
}

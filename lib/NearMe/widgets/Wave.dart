import 'dart:async';
import 'package:flutter/material.dart';

class Waves extends StatefulWidget {

  final Widget? center;
  final double? maxWidth;
  Waves({
    this.center,
    this.maxWidth,
  });

  @override
  _WavesState createState() => _WavesState();
}

class _WavesState extends State<Waves> {

  StreamController<Widget> controller = StreamController();
  List<Widget> list = [];

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getWaves();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Widget>(
      initialData: widget.center,
      stream: controller.stream,
      builder: (context, snapshot) {
        list.add(snapshot.data!);
        return Stack(
          alignment: Alignment.center,
          children: list,
        );
      }
    );
  }

  void getWaves() async {
    var noOfWaves = 5;
    for(int n = 1; n <= noOfWaves; n++){
      await Future.delayed(Duration(milliseconds: 1000));
      if(controller.isClosed) break;
      controller.sink.add(WaveAnimation(milliseconds: noOfWaves * 1000));
    }
  }
}

class WaveAnimation extends StatefulWidget {

  final int milliseconds, delay;
  final Color color;

  WaveAnimation({
    this.delay = 0,
    this.milliseconds = 1000,
    this.color = Colors.indigo,
  });


  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.milliseconds));
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child){
          return CustomPaint(
            painter: CirclePainter(color: widget.color, scale: animation.value),
            child: child,
          );
        },
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {

  final Color color;
  final double scale;
  CirclePainter({
    required this.scale,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Offset center = Offset(size.width/2, size.height/2);
    canvas.drawCircle(center, scale * size.width/2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
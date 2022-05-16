import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:near_me_ui/NearMe/model/User.dart';
import 'package:near_me_ui/NearMe/widgets/DragWidget.dart';

enum Rotations{
  Clockwise,
  Anticlockwise,
  Alternative
}

class RevolvingWidget extends StatefulWidget {

  final double? padding, shortestOrbitsDiameter, spaceBetOrbits;
  final int? milliseconds;
  final List<List<User>> orbits;
  final Rotations? rotations;
  final Color color;
  final Widget? center;

  RevolvingWidget({
    required this.orbits,
    this.padding,
    this.spaceBetOrbits = 50,
    this.shortestOrbitsDiameter = 100,
    this.milliseconds,
    this.rotations,
    this.color = Colors.indigo,
    this.center
  });

  @override
  _RevolvingWidgetState createState() => _RevolvingWidgetState();
}

class _RevolvingWidgetState extends State<RevolvingWidget> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          for(int index = widget.orbits.length-1; index >= 0; index--)
            OrbitWidget(orbit: widget.orbits[index], padding: widget.padding, milliseconds: widget.milliseconds, shortestOrbitsDiameter: widget.shortestOrbitsDiameter, spaceBetOrbits: widget.spaceBetOrbits, index: index, rotations: widget.rotations, color: widget.color),
          widget.center?? Center(),
        ],
      ),
    );
  }
}

class OrbitWidget extends StatefulWidget {

  final double? padding, spaceBetOrbits, shortestOrbitsDiameter;
  final int? milliseconds;
  final int index;
  final List<User> orbit;
  final Rotations? rotations;
  final Color color;

  OrbitWidget({
    required this.orbit,
    this.padding,
    required this.index,
    required this.shortestOrbitsDiameter,
    required this.spaceBetOrbits,
    this.milliseconds,
    this.rotations,
    required this.color,
  });

  @override
  _OrbitWidgetState createState() => _OrbitWidgetState();
}

class _OrbitWidgetState extends State<OrbitWidget> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;
  late int rotationDirection;

  @override
  void initState() {
    rotationDirection = ((widget.rotations == Rotations.Alternative? (widget.index.isEven? 1: -1): widget.rotations == Rotations.Clockwise? 1: -1));
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.milliseconds?? 2000));
    animation = Tween<double>(begin: 0, end: 2*pi).animate(controller);
    super.initState();
    controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double diameter = widget.shortestOrbitsDiameter! + (widget.index * widget.spaceBetOrbits!);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child){
        return Transform.rotate(
          angle: animation.value * rotationDirection,
          child: Stack(
            alignment: Alignment.center,
            children: [
              DottedBorder(
                color: widget.color,
                borderType: BorderType.Circle,
                child: ClipOval(
                  child: Container(
                    width: diameter-(widget.padding?? 20),
                    height: diameter-(widget.padding?? 20),
                  ),
                ),
              ),
              ...getPlanets(widget.orbit, (diameter/2)-(widget.padding?? 20)/2, animation.value * rotationDirection),
            ],
          ),
        );
      },
    );
  }

  List<Widget> getPlanets(List<User> orbit, double radius, double rotationAngle){
    List<Widget> planets = [];
    double angle = (2 * pi)/ orbit.length;
    for(int index = 0; index < orbit.length; index++){
      planets.add(
        Transform.translate(
          offset: Offset(radius * sin(index * angle), radius * cos(index * angle)),
          child: Transform.rotate(
            angle: -rotationAngle,
            child: Center(
              child: DraggableWidget(user: orbit[index])
            )
          ),
        )
      );
    }
    return planets;
  }
}
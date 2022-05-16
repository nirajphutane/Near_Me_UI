import 'dart:async';
import 'package:flutter/material.dart';
import 'package:near_me_ui/NearMe/model/User.dart';

class DraggableWidget extends StatefulWidget {

  final User user;
  DraggableWidget({
    required this.user,
  });

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  Animation? animation;
  Offset offset = Offset.zero;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed || status == AnimationStatus.dismissed){
        offset = Offset.zero;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child){
        return Transform.translate(
          offset: animation == null? Offset.zero: animation!.value,
          child: Draggable<User>(
            data: widget.user,
            child: widget.user.avatar,
            feedback: Transform.scale(child: widget.user.avatar, scale: 1.3),
            onDragUpdate: (dragUpdateDetails){
              offset += dragUpdateDetails.delta;
            },
            onDragEnd: (draggableDetails) {
              backToPosition();
            },
            childWhenDragging: const SizedBox(),
          ),
        );
      },
    );
  }

  void backToPosition(){
    animation = Tween<Offset>(begin: offset, end: Offset.zero).animate(controller);
    controller.reset();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


class DragTargetWidget extends StatefulWidget {

  final Function onAccept;
  DragTargetWidget({
    required this.onAccept
  });

  @override
  _DragTargetWidgetState createState() => _DragTargetWidgetState();
}

class _DragTargetWidgetState extends State<DragTargetWidget> {

  final StreamController<bool> controller = StreamController.broadcast();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<User>(
      builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
        return Hero(
          tag: 'hero',
          child: StreamBuilder<bool>(
            stream: controller.stream,
            initialData: false,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo, width: snapshot.data == true? 2: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Spacer(flex: 1),
                        Expanded(
                          flex: 2,
                          child: Icon(Icons.wifi_outlined, size: snapshot.data == true? 34: 30, color: Colors.indigo,)
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Connect...', style: TextStyle(color: Colors.indigo, fontSize: snapshot.data == true? 20: 18))
                        ),
                        Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        );
      },
      onMove: (DragTargetDetails<User> dragTargetDetails){
        controller.sink.add(true);
      },
      onLeave: (User? user){
        controller.sink.add(false);
      },
      onAccept: (User user){
        widget.onAccept(user);
      },
    );
  }

}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:near_me_ui/NearMe/model/User.dart';

class Connect extends StatefulWidget {

  final User user;
  final Animation<double> animation;
  Connect({
    required this.animation,
    required this.user,
  });

  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;
  late Animation animationColor;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    animationColor = ColorTween(begin: Colors.white, end: Colors.black).animate(controller);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Status'),
          centerTitle: true,
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, child){
            return FadeTransition(
              opacity: widget.animation,
              child: Material(
                child: Container(
                  color: animationColor.value,
                  child: Transform.translate(
                    offset: Offset(0, MediaQuery.of(context).size.height/4),
                    child: Hero(
                      tag: 'hero',
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 35),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 50),
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.indigo, width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(animation.value * 25.0)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(widget.user.name, style: TextStyle(color: Colors.indigo, fontSize: animation.value * 24)),
                                        Expanded(
                                          child: Center(
                                            child: DefaultTextStyle(
                                              style: TextStyle(fontSize: 1 + animation.value * 20.0, color: Colors.indigo),
                                              child: AnimatedTextKit(
                                                animatedTexts: [
                                                  WavyAnimatedText('Connected...'),
                                                ],
                                                isRepeatingAnimation: true,
                                              ),
                                            ),
                                          )
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Lottie.asset('assets/done_animation.json', height: animation.value * 70, width: animation.value * 70,),
                                            onTap: (){
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        Expanded(child: SizedBox(height: 30))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            FadeTransition(
                              opacity: animation,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                child: CircleAvatar(
                                  radius: 35.0,
                                  child: widget.user.avatar,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
    );
  }
}

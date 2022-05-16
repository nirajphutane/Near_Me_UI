import 'package:flutter/material.dart';
import 'dart:async';
import 'package:near_me_ui/NearMe/screens/ConnectScreen.dart';
import 'package:near_me_ui/NearMe/widgets/DragWidget.dart';
import 'package:near_me_ui/NearMe/widgets/RevolvingWidget.dart';
import 'package:near_me_ui/NearMe/widgets/Wave.dart';
import 'package:near_me_ui/NearMe/model/User.dart';

class NearMe extends StatefulWidget {

  @override
  _NearMeState createState() => _NearMeState();
}

class _NearMeState extends State<NearMe> {

  final StreamController<List<List<User>>> controller = StreamController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Near me'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 250),
                  CircleAvatar(child: FlutterLogo(size: 50), backgroundColor: Colors.indigo, radius: 35),
                  SizedBox(width: 20,),
                  Text('Niraj Phutane', style: TextStyle(color: Colors.indigo, fontSize: 30))
                ],
              )
            ),
            Align(
              alignment: Alignment.center,
              child: DragTargetWidget(onAccept: (User user){
                Navigator.push(context, PageRouteBuilder(
                  opaque: false,
                  transitionDuration: const Duration(seconds: 1),
                  reverseTransitionDuration: const Duration(seconds: 1),
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return Connect(animation: animation, user: user);
                  },
                ));
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<List<List<User>>>(
                initialData: [],
                stream: controller.stream,
                builder: (context, AsyncSnapshot<List<List<User>>> snapshot) {
                  return Transform.translate(
                    offset: Offset(0, MediaQuery.of(context).size.height / 2.5),
                    child: snapshot.data!.isEmpty?
                    Waves(
                      center: Text(
                        'Searching...',
                        style: TextStyle(color: Colors.indigo)
                      )
                    ):
                    RevolvingWidget(
                      orbits: snapshot.data!.toList(),
                      padding: 50,
                      milliseconds: 10000,
                      spaceBetOrbits: 75,
                      shortestOrbitsDiameter: 150,
                      rotations: Rotations.Alternative,
                      center: FloatingActionButton(
                        child: Icon(Icons.refresh_outlined),
                        onPressed: (){
                          getData();
                        },
                      ),
                    )
                  );
                }
              ),
            ),
          ],
        )
    );
  }

  void getData() async {
    controller.sink.add([]);
    await Future.delayed(Duration(seconds: 10));
    controller.sink.add([
      [
        User(name: 'Tony Stark', id: 11, avatar: Icon(Icons.account_circle, size: 40, color: Colors.teal)),
        User(name: 'Vision', id: 12, avatar: Icon(Icons.account_circle, size: 40, color: Colors.teal)),
        User(name: 'Natasha Romanoff', id: 13, avatar: Icon(Icons.account_circle, size: 40, color: Colors.teal)),
      ],
      [
        User(name: 'James Rhodes', id: 21, avatar: Icon(Icons.account_circle, size: 40, color: Colors.orangeAccent)),
        User(name: 'Pepper Potts', id: 22, avatar: Icon(Icons.account_circle, size: 40, color: Colors.orangeAccent)),
      ],
      [
        User(name: 'Steve Rogers', id: 31, avatar: Icon(Icons.account_circle, size: 40, color: Colors.lightGreen)),
        User(name: 'Nick Fury', id: 32, avatar: Icon(Icons.account_circle, size: 40, color: Colors.lightGreen)),
      ],
      [
        User(name: 'Stephen Strange', id: 41, avatar: Icon(Icons.account_circle, size: 40, color: Colors.deepOrange)),
        User(name: 'Loki', id: 42, avatar: Icon(Icons.account_circle, size: 40, color: Colors.deepOrange)),
        User(name: 'Thor', id: 43, avatar: Icon(Icons.account_circle, size: 40, color: Colors.deepOrange)),
        User(name: 'Bruce Banner', id: 44, avatar: Icon(Icons.account_circle, size: 40, color: Colors.deepOrange)),
        User(name: 'Wanda Maximoff', id: 45, avatar: Icon(Icons.account_circle, size: 40, color: Colors.deepOrange)),
      ],
    ]);
  }
}

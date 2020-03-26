import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:test8/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test8/main.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
String _question;

void main() => runApp(MyGame());

class MyGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const themeColor = const Color(0xffb77b);
    return new MaterialApp(
      title: 'Cherokee Learning Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: themeColor.withOpacity(1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.pinkAccent,
        buttonTheme: ButtonThemeData(
          height: 25,
          minWidth: 65,
        ),
      ),
      home: new GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<GamePage> with TickerProviderStateMixin {
  @override
  AnimationController controller;

  String get timeString {
    Duration duration = controller.duration * controller.value;
    return '${(duration.inSeconds).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    const thiscolor = const Color(0x6BA7B5);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                                painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: themeData.indicatorColor,
                                ));
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Time Left",
                              style: themeData.textTheme.subhead,
                            ),
                            AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  return Text(
                                    timeString,
                                    style: themeData.textTheme.display4,
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Current Phrase Goes Here",

                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment(-.4, 0.9),
                // Switch register Button
                child: Form(

                  // TODO: make a response form for the round?
                  // key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a Respose',
                          ),
                          autofocus: false,
                          // TODO: Change to a response submission
                          onSaved: (input) => _question = input
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submit"),
                          onPressed: saveQuestion,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    // TODO: implement repaint
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

void saveQuestion() async{
    print(_question);
    Firestore.instance
        .collection('gameSessions')
        .document("3156")
        .collection('players')
        .document(currUser)
        .updateData({
      'question': _question,
    });

}


//void main() => runApp(MyGame());
//
//
//class MyGame extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    const themeColor = const Color(0xffb77b);
//    return new MaterialApp(
//      title: 'Cherokee Learning Game',
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        canvasColor: themeColor.withOpacity(1),
//        iconTheme: IconThemeData(
//          color: Colors.white,
//        ),
//        accentColor: Colors.pinkAccent,
//        buttonTheme: ButtonThemeData(
//          height: 25,
//          minWidth: 65,
//        ),
//      ),
//      home: new GamePage(),
//    );
//  }
//}
//
//class GamePage extends StatefulWidget {
//  @override
//  _MyHomePageState createState() => new _MyHomePageState();
//}
//
//class _MyHomePageState extends State<GamePage> with TickerProviderStateMixin {
//  @override
//  AnimationController controller;
//
//  String get timeString {
//    Duration duration = controller.duration * controller.value;
//    return '${(duration.inSeconds).toString().padLeft(2, '0')}';
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    controller = AnimationController(
//      vsync: this,
//      duration: Duration(seconds: 30),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    ThemeData themeData = Theme.of(context);
//    const thiscolor = const Color(0x6BA7B5);
//    return Scaffold(
//      body: Padding(
//        padding: EdgeInsets.all(8.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Expanded(
//              child: Align(
//                alignment: FractionalOffset.center,
//                child: AspectRatio(
//                  aspectRatio: 1.0,
//                  child: Stack(
//                    children: <Widget>[
//                      Positioned.fill(
//                        child: AnimatedBuilder(
//                          animation: controller,
//                          builder: (BuildContext context, Widget child) {
//                            return CustomPaint(
//                                painter: TimerPainter(
//                                  animation: controller,
//                                  backgroundColor: Colors.white,
//                                  color: themeData.indicatorColor,
//                                ));
//                          },
//                        ),
//                      ),
//                      Align(
//                        alignment: FractionalOffset.center,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Text(
//                              "Time Left",
//                              style: themeData.textTheme.subhead,
//                            ),
//                            AnimatedBuilder(
//                                animation: controller,
//                                builder: (BuildContext context, Widget child) {
//                                  return Text(
//                                    timeString,
//                                    style: themeData.textTheme.display4,
//                                  );
//                                }),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            Container(
//              margin: EdgeInsets.all(25.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Text(
//                    "Current Phrase Goes Here",
//
//                  ),
//                ],
//              ),
//            ),
//
//
//            Container(
//              child: Align(
//                alignment: Alignment(-.4, 0.9),
//                // Switch register Button
//                child: RaisedButton(
//                  onPressed: () async {
//                    print('clicked');
//                    showDialog(
//                        context: context,
//                        builder: (BuildContext context) {
//                          return AlertDialog(
//                            content: Form(
//
//                              // TODO: make a response form for the round?
//                              // key: _formKey,
//
//                              child: Column(
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  Padding(
//                                    padding: EdgeInsets.all(8.0),
//                                    child: TextFormField(
//                                      decoration: InputDecoration(
//                                        border: OutlineInputBorder(),
//                                        hintText: 'Enter Password Here',
//                                      ),
//                                      autofocus: false,
//                                      obscureText: true,
//
//                                      // TODO: Change to a response submission
//                                      onSaved: (input) => _question = input,
//                                      //onSaved: (input) =>
//                                      // _passwordReg = input
//
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: RaisedButton(
//                                      child: Text("Submit"),
//                                      onPressed: () async {
//                                        Firestore.instance
//                                            .collection('gameSessions')
//                                            .document(joinRoomNum)
//                                            .collection('players')
//                                            .document(currUser)
//                                            .updateData({
//                                          'question': _question,
//                                        });
//                                      },
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          );
//                        });
//                  },
//                  child: Text('Register', style: TextStyle(fontSize: 10)),
//                  color: thiscolor.withOpacity(1),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(10.0),
//                  ),
//                  textColor: Colors.white,
//                  elevation: 15,
//                ),
//              ),
//            ),
//
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class TimerPainter extends CustomPainter {
//  TimerPainter({
//    this.animation,
//    this.backgroundColor,
//    this.color,
//  }) : super(repaint: animation);
//  final Animation<double> animation;
//  final Color backgroundColor;
//  final Color color;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    Paint paint = Paint()
//      ..color = backgroundColor
//      ..strokeWidth = 5
//      ..strokeCap = StrokeCap.round
//      ..style = PaintingStyle.stroke;
//    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
//    paint.color = color;
//    double progress = (1.0 - animation.value) * 2 * math.pi;
//    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
//  }
//
//  @override
//  bool shouldRepaint(TimerPainter old) {
//    // TODO: implement repaint
//    return animation.value != old.animation.value ||
//        color != old.color ||
//        backgroundColor != old.backgroundColor;
//  }
//}
//
//void respond() async{}
//
//
//
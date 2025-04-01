import 'package:flutter/material.dart';
import 'homepage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'DINCondensedBold',
      ),
      home: LyonAnimationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LyonAnimationPage extends StatefulWidget {
  @override
  _LyonAnimationPageState createState() => _LyonAnimationPageState();
}

class _LyonAnimationPageState extends State<LyonAnimationPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _letterAnimations;
  late List<Animation<double>> _lineAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

     _letterAnimations=List.generate(4, (index){
      double start=(index*0.2).clamp(0.0,1.0);
      double end=(start+0.2).clamp(start,1.0);
      return Tween <double>(begin: 0.0,end:1.0).animate(
        CurvedAnimation(
          parent:_controller,
          curve:Interval(start, end,curve: Curves.easeOut)
        )
      );
     });

  
    _lineAnimations = List.generate(5, (index) {
      double start = (0.8 + (index * 0.1)).clamp(0.0, 1.0);
      double end = (start + 0.1).clamp(start, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
            
              Container(color: Colors.purple[900]),

              // Center animations
              Center(
                child: Stack(
                  children: [
                    buildAnimatedLetter('L', -100, -130, _letterAnimations[0]),
                    buildAnimatedLetter('Y', 0, -50, _letterAnimations[1]),
                    buildAnimatedLetter('O', 100, -50, _letterAnimations[2], isImage: true),
                    buildAnimatedLetter('N', 200, -50, _letterAnimations[3]),

                    buildAnimatedLine(-130, -40, _lineAnimations[0]),
                    buildAnimatedLine(-140, 120, _lineAnimations[1]),
                    buildAnimatedLine(30, 120, _lineAnimations[2]),
                    buildAnimatedLine(170, -60, _lineAnimations[3]),
                    buildAnimatedLine(250, 160, _lineAnimations[4]),
                    FloatingActionButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>HistoryScreen()));},child: Icon(Icons.arrow_forward),backgroundColor: Colors.pink,),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildAnimatedLetter(String letter, double x, double y, Animation<double> animation,
      {bool isImage = false}) {
    return Positioned(
      left: 150 + (x * animation.value),
      top: 300 + (y * animation.value),
      child: Opacity(
        opacity: animation.value,
        child: isImage
            ? ClipPath(
                clipper: OImageClipper(),
                child: Image.asset(
                  'assets/moment-6.jpeg',
                  width: 80,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                letter,
                style: TextStyle(
                  fontSize: 200,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget buildAnimatedLine(double x, double y, Animation<double> animation) {
    return Positioned(
      left: 150 + (x * animation.value),
      top: 300 + (y * animation.value),
      child: Opacity(
        opacity: animation.value,
        child: Transform.rotate(
          angle: -0.7,
          child: Container(
            width: 80,
            height: 10,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}

class OImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    
   
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));


    Path hole = Path();
    hole.addOval(Rect.fromLTWH(
      size.width * 0.25, 
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.5,
    ));

   
    path = Path.combine(PathOperation.difference, path, hole);
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true; 
}


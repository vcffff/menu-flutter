import 'package:flutter/material.dart';
import 'dart:async';
import 'recpmmend.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LyonPage(),
    );
  }
}

class LyonPage extends StatefulWidget {
  @override
  _LyonPageState createState() => _LyonPageState();
}

class _LyonPageState extends State<LyonPage> {
  final List<String> imagePaths = [
    'assets/moment-1.jpeg',
    'assets/moment-2.jpeg',
    'assets/moment-3.jpeg',
    'assets/moment-4.jpeg',
    'assets/moment-5.jpeg',
    'assets/moment-6.jpeg',
    'assets/moment-7.jpeg',
    'assets/moment-8.jpeg',
    'assets/moment-9.jpeg',
    'assets/moment-10.jpeg',
  ];

  late ScrollController leftScrollController;
  late ScrollController rightScrollController;

  @override
  void initState() {
    super.initState();
    leftScrollController = ScrollController();
    rightScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoScroll(leftScrollController, 1);
      startAutoScroll(rightScrollController, -1);
    });
  }

  void startAutoScroll(ScrollController controller, int direction) {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!mounted || !controller.hasClients) return;

      double newOffset = controller.offset + (0.5 * direction);
      
      if (newOffset >= controller.position.maxScrollExtent) {
        controller.jumpTo(0);
      } else if (newOffset <= controller.position.minScrollExtent) {
        controller.jumpTo(controller.position.maxScrollExtent);
      } else {
        controller.jumpTo(newOffset);
      }
    });
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.purple[900],
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row( 
          children: [
            Expanded(
              flex: 1, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
            RichText(text: TextSpan(
              text: 'Unforgettable',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
            )),
            RichText(text: TextSpan(text: 'Moments In',style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),children: [TextSpan(text: ' Lyon',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold))])),
                  SizedBox(height: 10),
                  Text(
                    "Lyon, the third-largest city in France, is a charming destination that offers a rich blend of history, culture, and culinary delights.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatistic("5.5M+", "Visitors"),
                      SizedBox(width: 20),
                      _buildStatistic("10.2M+", "Photography"),
                      FloatingActionButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>finAL()));},child: Icon(Icons.arrow_forward),backgroundColor: Colors.pink,),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
                    child: Text("Explore",style: TextStyle(color:   Colors.white),),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: _buildGallery(leftScrollController, imagePaths)),
                  SizedBox(width: 10),
                  Expanded(child: _buildGallery(rightScrollController, imagePaths.reversed.toList())),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildStatistic(String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.white70)),
      ],
    );
  }

  Widget _buildGallery(ScrollController controller, List<String> images) {
    return ListView.builder(
      controller: controller,
      itemCount: images.length * 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(width: double.infinity,height: 270, decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: Colors.white,
      width: 3,
    ), image: DecorationImage(fit: BoxFit.cover, image:  AssetImage(images[index % images.length],)),
          ),
            ),
          )
        );
      },
    );
  }
}

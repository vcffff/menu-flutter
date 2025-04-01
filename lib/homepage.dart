import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'moment.dart';
import 'expandmap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'DINCondensedBold',
      ),
      debugShowCheckedModeBanner: false,
      home: HistoryScreen(),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map> items = [];

  @override
  void initState() {
    super.initState();
    jojo();
  }

  Future<void> jojo() async {
    String hello = await rootBundle.loadString('assets/histories.json');
    setState(() {
      items = List<Map>.from(json.decode(hello));
    });
  }

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToPage(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "History of Lyon",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            text: 'Lyon is the ancient',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            children:[
                              TextSpan(text: ' capital of Gaul',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold)),
                             
                            ]
                          ),
                          ),
                        RichText(text: TextSpan(
                          text: 'with a rich history of ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          children: [TextSpan(text: 'more than 2000 years.',style:TextStyle(color: Colors.pink,fontWeight: FontWeight.bold) ),           
                                  ]            ))
                      ]
                      
                    ),
                  ),
                ),
              ],
            ),
           Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: items.isNotEmpty  // ✅ Check if `items` is not empty
      ? List.generate(items.length, (index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => _goToPage(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 50,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.pink : Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(
                items[index]['phase'],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _currentIndex == index ? Colors.pink : Colors.white,
                ),
              ),
            ],
          );
        })
      : 
      []
),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: items.isNotEmpty
                    ? List.generate(items.length, (index) {
                        return HistoryPage(
                          title: items[index]['phase'],
                          content: items[index]['intro'],
                         image: Image.asset(items[index]['image'],width: 300,height: 200,),
                         period:items[index]['time_range']
                        );
                      })
                    : [Center(child: FloatingActionButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>LyonPage()));},child: Icon(Icons.arrow_forward),backgroundColor: Colors.pink,))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final String title;
  final String content;
  final Image image;
  final String period;

  const HistoryPage({required this.title, required this.content, required this.image,required this.period});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Row(
            children: [
              image , 
              Container(width: 300,height: 500,
              padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            period,
                            style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                   
                      child: Text(
                        content,
                        style: TextStyle(fontSize: 11,color: Colors.white38,fontFamily:'DINCondensedBold'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 25),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LyonPage()),
                        );
                      },
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                      backgroundColor: Colors.pink,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

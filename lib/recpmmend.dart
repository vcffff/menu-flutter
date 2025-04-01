import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' ;
import 'package:moduleb/moment.dart';
import 'expandmap.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: finAL(),
    );
  }
}

class finAL extends StatefulWidget {
  @override
  _LyonPageState createState() => _LyonPageState();
}

class _LyonPageState extends State<finAL> {
  bool showThingsToDo = true;
  bool showBudget = true;
  bool showRating = true;
  List<dynamic> comments = [];
  List<dynamic> recommendations = [];
  List<String> images = [
    'assets/parc-de-la-tete-d-or.jpg',
    'assets/vieux-lyon.jpg',
    'assets/renaissance.jpg',
    'assets/roman.jpg',
  ];

  @override
  void initState() {
    super.initState();
    loadComments();
    loadRecommendations();
  }

  Future<void> loadComments() async {
    try {
      String data = await rootBundle.loadString('assets/comments.json');
      setState(() {
        comments = json.decode(data);
      });
    } catch (e) {
      print("Error loading comments.json: $e");
      setState(() {
        comments = []; 
      });
    }
  }

  Future<void> loadRecommendations() async {
    String data = await rootBundle.loadString('assets/recommends.json');
    setState(() {
      recommendations = json.decode(data);
    });
  }

  bool changer=true;
  bool changer2=true;
  bool changer3=true;
  bool changer4=true;
  RangeValues current=const RangeValues(40, 100);
  Widget _buildExpandableSection(String title, bool isExpanded, VoidCallback toggle, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: toggle,
          ),
        ),
        if (isExpanded) content,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExpandableSection(
                  "Things to do",
                  showThingsToDo,
                  () => setState(() => showThingsToDo = !showThingsToDo),
                  Wrap(
                    spacing: 5,
                    children: [
                      Chip(label: Text("Walking")),
                      Chip(label: Text("Culinary")),
                      Chip(label: Text("Historic Areas")),
                      Chip(label: Text("Wine Tastings")),
                    ],
                  ),
                ),
                _buildExpandableSection(
                  "Budget",
                  showBudget,
                  () => setState(() => showBudget = !showBudget),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Chip(label: Text("\$200.000")),
                          Chip(label: Text("\$800.000")),
                        ],
                      ),
                  RangeSlider(values: current, onChanged: (RangeValues values){setState(() {
                    current=values; 
                  });},max: 100,divisions: 5,labels: RangeLabels(current.start.round().toString(),current.end.round.toString()),)
                    
                    ],
                  ),
                ),
                _buildExpandableSection(
                  "Traveler rating",
                  showRating,
                  () => setState(() => showRating = !showRating),
                  Column(
                    children: [
                    
                    
                      Row(
                        children:[ IconButton(onPressed: (){setState(() {
                          changer=!changer;
                        });}, icon:Icon(changer? Icons.circle_outlined:Icons.circle,color:  Colors.black)),
                        ...List.generate(
                          5, 
                          (index) => Icon(
                            Icons.star, 
                            color: Colors.yellow ,
                          ),
                        ),]
                      ),
                        Row(
                        children: [IconButton(onPressed: (){setState(() {
                          changer2=!changer2;
                        });}, icon:Icon(changer2?Icons.circle_outlined:Icons.circle,color: Colors.black)),
                          ...List.generate(5, (index) => Icon(Icons.star, color: index < 4 ? Colors.yellow : Colors.grey)),
                          SizedBox(width: 8),
                          Text("&up", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[900])),
                        ],
                      ),
                      Row(children: [IconButton(onPressed: (){setState(() {
                        changer3=!changer3;                      });}, icon:Icon(changer3? Icons.circle_outlined:Icons.circle,color: Colors.black)),
                    ...List.generate(5, (index) => Icon(Icons.star, color: index < 3 ? Colors.yellow : Colors.grey)),
                          SizedBox(width: 8),
                          Text("&up", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[900])),
                          ],),
                          
                           Row(children: [IconButton(onPressed: (){setState(() {
                             changer4=!changer4;
                           });}, icon:Icon(changer4?Icons.circle_outlined:Icons.circle,color: Colors.black,)),
                    ...List.generate(5, (index) => Icon(Icons.star, color: index < 2 ? Colors.yellow : Colors.grey)),
                          SizedBox(width: 8),
                          Text("&up", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[900])),
                          ],)
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
           
                Stack(
                  children:[ Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/map.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),Positioned(bottom: 10,right: 10, child: IconButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>Bigmap()));}, icon: Icon(Icons.zoom_in_map_outlined)))]
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recommendations
                      Expanded(
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Recommended to you", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.pink)),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  mainAxisExtent: 200,
                                ),
                                itemCount: recommendations.length,
                                itemBuilder: (context, index) {
                                  final rec = recommendations[index];
                                  return Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: AssetImage(images[index % images.length]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 19,
                                        left: 10,
                                        child: Container(
                                          color: Colors.black.withOpacity(0.5),
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            rec['title'],
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                          
                                        ),
                                      ),
                                      Positioned(child: Text(rec['tag'],style: TextStyle(color: Colors.white),),bottom:1,left: 15,)
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Comments
                      Expanded(
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Comments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.pink)),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(comment['avatar'] ?? 'assets/oliver.png'),
                                    ),
                                    title: Text(comment['question'] ?? 'No question provided'),
                                    subtitle: Text(comment['answer'] ?? 'No answer provided'),
                                    trailing: Text("${comment['likes'] ?? 0} likes"),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

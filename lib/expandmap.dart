import 'package:flutter/material.dart';
import 'package:moduleb/recpmmend.dart';

class Bigmap extends StatefulWidget {
  const Bigmap({super.key});

  @override
  State<Bigmap> createState() => _BigmapState();
}

class _BigmapState extends State<Bigmap> with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
      if (hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _navigateToRecommendationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => finAL()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/map.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            child: Focus(
              onFocusChange: _onFocusChange,
              child: TextField(
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_isFocused ? 20 : 40),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _navigateToRecommendationPage,
                        icon: const Icon(Icons.arrow_back, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isFocused)
            Positioned(
              top: 100,
              left: 20,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 260,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          ListTile(title: Text('Suggestion 1')),
                          ListTile(title: Text('Suggestion 2')),
                          ListTile(title: Text('Suggestion 3')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


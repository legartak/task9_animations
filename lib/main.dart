import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimationDemo(),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  _AnimationDemoState createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // Change the duration as needed
    );

    _colorAnimation = RainbowTween(begin: Colors.red, end: Colors.red).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _positionAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rainbow Square Animation'),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double x = _positionAnimation.value *
                  (MediaQuery.of(context).size.width -
                      50); // Subtract 50 for the square size

              return Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(
                  left: x,
                  // top: 160, // Center vertically
                ),
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  shape: BoxShape.rectangle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RainbowTween extends Tween<Color?> {
  RainbowTween({super.begin, super.end});

  @override
  Color? lerp(double t) {
    const double segment = 1.0 / 6.0;
    int segmentIndex = (t / segment).floor();
    double segmentT = (t - segment * segmentIndex) / segment;

    double progress = 255 * segmentT;

    int r = 0, g = 0, b = 0;

    switch (segmentIndex) {
      case 0:
        r = 255.round();
        g = progress.round();
        break;
      case 1:
        r = (255 - progress).round();
        g = 255.round();
        break;
      case 2:
        g = 255.round();
        b = progress.round();
        break;
      case 3:
        g = (255 - progress).round();
        b = 255.round();
        break;
      case 4:
        r = progress.round();
        b = 255.round();
        break;
      case 5:
        r = 255.round();
        b = (255 - progress).round();
        break;
    }

    return Color.fromRGBO(r, g, b, 1.0);
  }
}

import 'package:flutter/material.dart';
import 'dart:async' show Timer;

void main() {

  var timer = const Duration( milliseconds: 75 ); // How often to update i.e. how fast the animation is

  runApp(MaterialApp (
    home: Scaffold (
      body: Center (
        child: AnimatedText( timer )
      )
    )
  ));
}

class AnimatedText extends StatefulWidget {

  final Duration period; // Time period for update

  AnimatedText( this.period );
  @override
  _AnimatedText createState() => _AnimatedText( period );
}


class _AnimatedText extends State<AnimatedText> {

  bool forward = true; // Text should go forward?

  Timer timer; // Timer Objects allow us to do things based on a period of time
  // We want to get an array of characters, but Dart does not have a char type
  // Below is the equivalent code
  var _text =  'Hello World!      '.runes // .runes gives us the unicode number of each character
    .map( (code) => String.fromCharCode(code) ) // Map all these codes to Strings containing the single character
    .toList(); // Conver to a List

  _AnimatedText( Duration period ){
    timer = Timer.periodic( period , (_){
      setState((){ // Set state forces the gui elements to be redrawn
        shiftText();

      });
    });
  }

  String get text => _text.join(''); // Getter, joins the list of chars into a string

  void shiftText() {
    if (forward) { // If we should go forward
      var last = _text.removeLast(); // Remove the last char

      _text.insert( 0, last); // Insert it at the front

    } else { // If we should go backward
      var first = _text.removeAt(0); // Remove the first char

      _text.insert( _text.length, first ); // Insert it at the end
    }

 }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // GestureDetector lets us capture events
      onTap: () => forward = !forward, // on Tap (Click in browser) invert the forward bool
      child: Text(
        text, // Call the text getter to get the shifted string
        style: TextStyle( // Styling
          fontSize: 50,
          color: Colors.grey[600]
        )
      )

    );
  }

}

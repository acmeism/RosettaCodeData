import 'package:flutter/material.dart';

main() => runApp( OutputLabel() );

class OutputLabel extends StatefulWidget {
  @override
  _OutputLabelState createState() => _OutputLabelState();
}

class _OutputLabelState extends State<OutputLabel> {
  String output = "output"; // This will be displayed in an output text field

  TextEditingController _stringInputController = TextEditingController(); // Allows us to get the text from a text field
  TextEditingController _numberInputController = TextEditingController();

  @override
  Widget build( BuildContext context ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner in top right
      home: Scaffold ( // Scaffold provides a layout for the app
        body: Center ( // Everything in the center widget will be centered
          child: Column ( // All the widgets will be in a column
            children: <Widget> [
              SizedBox( height: 25 ), // Space between top and text field

              TextField ( // String input Text Field
                controller: _stringInputController, // Add input controller so we can grab text
                textAlign: TextAlign.center, // Center text
                decoration: InputDecoration( border: OutlineInputBorder(), labelText: 'Enter a string...'), // Border and default text
              ), // end TextField

              SizedBox( height: 10 ), // Space between text fields

              TextField ( // Number input Text Field
                controller: _numberInputController, // Add input controller so we can grab text
                textAlign: TextAlign.center, // Center text
                decoration: InputDecoration( border: OutlineInputBorder(), labelText: 'Enter 75000'), // Border and default text
              ), // end TextField

              FlatButton ( // Submit Button
                child: Text('Submit Data'), // Button Text
                color: Colors.blue[400] // button color
                onPressed: () { // On pressed Callback for button
                  setState( () {
                    output = ''; // Reset output

                    int number; // Int to store number in

                    var stringInput = _stringInputController.text ?? ''; // Get the input from the first field, if it is null set it to an empty string

                    var numberString = _numberInputController.text ?? ''; // Get the input from the second field, if it is null set it to an empty string

                    if ( stringInput == '')  { // If first field is empty
                      output = 'Please enter something in field 1\n';
                      return;
                    }

                    if (_numberInputController.text == '') { // If second field is empty
                      output += 'Please enter something in field 2';
                      return;
                    } else { // If we got an input in the second field

                      try {
                        number = int.parse( numberString ); // Parse numberString into an int

                        if ( number == 75000 )
                          output = 'text output: $stringInput\nnumber: $number'; // Grabs the text from the input controllers and changes the string
                        else
                          output = '$number is not 75000!';

                      } on FormatException { // If a number is not entered in second field
                          output = '$numberString is not a number!';
                      }

                    }

                  });
                }
              ), // End FlatButton

              Text( output ) // displays output

            ]
          )
        )
      )
    );
  }
}

|num|
num := (5 raisedTo: (4 raisedTo: (3 raisedTo: 2))) asString.
Transcript
   show: (num first: 20), '...', (num last: 20); cr;
   show: 'digits: ', num size asString.

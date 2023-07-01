program GuessTheNumber;

{$APPTYPE CONSOLE}

uses SysUtils;

var
  theDigit : String ;
  theAnswer : String ;

begin
  Randomize ;
  theDigit := IntToStr(Random(9)+1) ;
  while ( theAnswer <> theDigit ) do Begin
    Writeln('Please enter a digit between 1 and 10' ) ;
    Readln(theAnswer);
  End ;
  Writeln('Congratulations' ) ;
end.

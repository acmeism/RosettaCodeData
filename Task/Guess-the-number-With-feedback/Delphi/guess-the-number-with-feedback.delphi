program GuessTheNumber;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Math;


const
  // Set min/max limits
  min: Integer = 1;
  max: Integer = 10;

var
  last,
  val,
  inp: Integer;
  s: string;

  // Initialise new game
  procedure NewGame;
  begin
    // Make sure this number isn't the same as the last one
    repeat
      val := RandomRange(min,max);
    until
      val <> last;

    // Save this number
    last := val;
    Writeln('Guess a number between ', min, ' and ', max, ' [Answer = ', val, ']');
  end;

begin
  // Initialise the random number generator with a random value
  Randomize;

  // Initialise last number
  last := 0;

  // Initialise user input
  s := '';

  // Start game
  NewGame;

  // Loop
  repeat
    // User input
    Readln(s);

    // Validate - checxk if input is a number
    if TryStrToInt(s,inp) then
      begin
        // Is it the right number?
        if (inp = val) then
          begin
            // Yes - request a new game
            Writeln('Correct! Another go? Y/N');
            Readln(s);
            if SameText(s,'Y') then
              // Start new game
              NewGame
              else
              Exit;
          end
          else
          // Input too low/high
          if (inp < val) then
            Writeln('Too low! Try again...')
            else
            if (inp > val) then
              Writeln('Too high! Try again...');
      end
      else
      // Input invalid
      if not SameText(s,'bored') then
        Writeln('Invalid input! Try again...');

  until
    SameText(s,'bored');


end.

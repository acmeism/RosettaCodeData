program MontyHall;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  numGames = 1000000;   // Number of games to run

var
  switchWins, stayWins, plays: Int64;
  doors: array[0..2] of Integer;
  i, winner, choice, shown: Integer;
begin
  switchWins := 0;
  stayWins := 0;

  for plays := 1 to numGames do
  begin

    //0 is a goat, 1 is a car
    for i := 0 to 2 do
      doors[i] := 0;

    //put a winner in a random door
    winner := Random(3);
    doors[winner] := 1;

    //pick a door, any door
    choice := Random(3);

	  //don't show the winner or the choice
    repeat
      shown := Random(3);
    until (doors[shown] <> 1) and (shown <> choice);

    //if you won by staying, count it
    stayWins := stayWins + doors[choice];

    //the switched (last remaining) door is (3 - choice - shown), because 0+1+2=3
    switchWins := switchWins + doors[3 - choice - shown];
  end;

  WriteLn('Staying wins   ' + IntToStr(stayWins) + ' times.');
  WriteLn('Switching wins ' + IntToStr(switchWins) + ' times.');
end.

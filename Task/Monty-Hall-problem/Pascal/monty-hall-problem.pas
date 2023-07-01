program MontyHall;

uses
  sysutils;

const
  NumGames = 1000;


{Randomly pick a door(a number between 0 and 2}
function PickDoor(): Integer;
begin
  Exit(Trunc(Random * 3));
end;

var
  i: Integer;
  PrizeDoor: Integer;
  ChosenDoor: Integer;
  WinsChangingDoors: Integer = 0;
  WinsNotChangingDoors: Integer = 0;
begin
  Randomize;
  for i := 0 to NumGames - 1 do
  begin
    //randomly picks the prize door
    PrizeDoor := PickDoor;
    //randomly chooses a door
    ChosenDoor := PickDoor;

    //if the strategy is not changing doors the only way to win is if the chosen
    //door is the one with the prize
    if ChosenDoor = PrizeDoor then
      Inc(WinsNotChangingDoors);

    //if the strategy is changing doors the only way to win is if we choose one
    //of the two doors that hasn't the prize, because when we change we change to the prize door.
    //The opened door doesn't have a prize
    if ChosenDoor <> PrizeDoor then
      Inc(WinsChangingDoors);
  end;

  Writeln('Num of games:' + IntToStr(NumGames));
  Writeln('Wins not changing doors:' + IntToStr(WinsNotChangingDoors) + ', ' +
    FloatToStr((WinsNotChangingDoors / NumGames) * 100) + '% of total.');

  Writeln('Wins changing doors:' + IntToStr(WinsChangingDoors) + ', ' +
    FloatToStr((WinsChangingDoors / NumGames) * 100) + '% of total.');

end.

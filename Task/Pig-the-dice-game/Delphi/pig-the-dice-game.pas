program Pig_the_dice_game;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Console;

var
  playerScores: TArray<Integer> = [0, 0];
  turn: Integer = 0;
  currentScore: Integer = 0;
  player: Integer;

begin
  Randomize;

  turn := Random(length(playerScores));
  writeln('Player ', turn, ' start:');

  while True do
  begin
    Console.Clear;

    for var i := 0 to High(playerScores) do
    begin
      Console.ForegroundColor := TConsoleColor(i mod 15 + 1);
      Writeln(format('Player %2d has: %3d points', [i, playerScores[i]]));
    end;
    Writeln(#10);

    player := turn mod length(playerScores);
    Console.ForegroundColor := TConsoleColor(player mod 15 + 1);

    writeln(format('Player %d [%d, %d], (H)old, (R)oll or (Q)uit: ', [player,
      playerScores[player], currentScore]));
    var answer := Console.ReadKey.KeyChar;

    case UpCase(answer) of
      'H':
        begin
          playerScores[player] := playerScores[player] + currentScore;
          writeln(format('    Player %d now has a score of %d.'#10, [player,
            playerScores[player]]));
          if playerScores[player] >= 100 then
          begin
            writeln('    Player ', player, ' wins!!!');
            readln;
            halt;
          end;

          currentScore := 0;
          inc(turn);
        end;

      'R':
        begin
          var roll := Random(6) + 1;
          if roll = 1 then
          begin
            writeln('    Rolled a 1. Bust!'#10);
            currentScore := 0;
            inc(turn);

            writeln('Press any key to pass turn');
            Console.ReadKey;
          end
          else
          begin
            writeln('    Rolled a ', roll, '.');
            inc(currentScore, roll);
          end;
        end;
      'Q':
        halt;
    else
      writeln('  Please enter one of the given inputs.');
    end;
  end;
  writeln(format('Player %d wins!!!', [(turn - 1) mod Length(playerScores)]));
  Readln;
end.

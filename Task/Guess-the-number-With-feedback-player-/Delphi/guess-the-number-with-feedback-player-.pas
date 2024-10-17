program Guess_the_number;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  system.console;

type
  TCharSet = set of char;

var
  PlayerNumber, CPUNumber: word;
  CPULow: word = 0;
  CPUHi: word = 1000;
  PlayerLow: word = 0;
  PlayerHi: word = 1000;
  CPUWin, PlayerWin: boolean;
  CPUGuessList: string = 'Previus guesses:'#10;
  PlayerGuessList: string = 'Previus guesses:'#10;

function WaitKey(validSet: TCharSet): char;
begin
  repeat
    Result := Console.ReadKey.KeyChar;
  until (Result in validSet);
end;

function QueryNumber(msg: string): Integer;
var
  buf: string;
begin
  repeat
    Console.WriteLine(msg);
    buf := Console.ReadLine.Replace(#10, '').Replace(#13, '');
  until TryStrToInt(buf, result);
end;

procedure Wait;
begin
  Console.ForegroundColor := TConsoleColor.Yellow;
  Console.WriteLine(#10'Press Enter to continue');
  WaitKey([#13]);
  Console.ForegroundColor := TConsoleColor.White;
end;

function PlayLuck: integer;
var
  cpu, player: double;
begin
  cpu := CPUHi - CPULow + 1;
  player := PlayerHi - PlayerLow + 1;

  Result := round(100 * cpu / (cpu + player));
end;

function PlayerTurn: boolean;
var
  guess: word;
begin
  Console.Clear;
  Console.WriteLine('Player Turn({0}%%):'#10, [PlayLuck]);
  Console.ForegroundColor := TConsoleColor.Gray;
  console.WriteLine(PlayerGuessList + #10);

  console.WriteLine(#10 + 'Tip: {0}..{1}' + #10, [PlayerLow, PlayerHi]);
  Console.ForegroundColor := TConsoleColor.Red;

  guess := QueryNumber('Enter your guess number:');
  Console.ForegroundColor := TConsoleColor.White;

  if guess > CPUNumber then
  begin
    Console.WriteLine('{0} is to high', [guess]);
    PlayerGuessList := PlayerGuessList + '   ' + guess.tostring + ' is to high'#10;
    PlayerHi := guess - 1;
  end;

  if guess < CPUNumber then
  begin
    Console.WriteLine('{0} is to Low', [guess]);
    PlayerGuessList := PlayerGuessList + '   ' + guess.tostring + ' is to low'#10;
    PlayerLow := guess + 1;
  end;

  Result := guess = CPUNumber;
  if Result then
    Console.WriteLine('Your guess is correct, you rock!')
  else
    Wait;
end;

function CPUTurn: boolean;
var
  guess: word;
  ans: char;
begin
  guess := ((CPUHi - CPULow) div 2) + CPULow;

  Console.Clear;
  Console.WriteLine('CPU Turn({0}%%):'#10, [100 - PlayLuck]);
  Console.ForegroundColor := TConsoleColor.Gray;
  console.WriteLine(CPUGuessList + #10);
  console.WriteLine(#10 + 'Tip: {0}..{1}' + #10, [CPULow, CPUHi]);
  Console.ForegroundColor := TConsoleColor.Red;
  Console.WriteLine('My guess number is {0}'#10, [guess]);
  Console.ForegroundColor := TConsoleColor.White;

  Console.WriteLine('Press "l" = too low, "h" = too high, "c" = correct', [guess]);
  ans := WaitKey(['l', 'h', 'c']);

  Result := false;
  case ans of
    'l':
      begin
        CPULow := guess + 1;
        Console.WriteLine(#10'Then my guess is to low'#10);
        CPUGuessList := CPUGuessList + '   ' + guess.tostring + ' is to low'#10;
      end;
    'h':
      begin
        CPUHi := guess - 1;
        Console.WriteLine(#10'Then my guess is to high'#10);
        CPUGuessList := CPUGuessList + '   ' + guess.tostring + ' is to high'#10;
      end
  else
    Result := True;
  end;

  if Result then
    Console.WriteLine(#10'My guess is correct, Good luck in the next time')
  else
    Wait;
end;

begin
  Randomize;
  CPUNumber := Random(1001);
  Console.WriteLine('Press Enter and I will start to guess the number.');

  repeat
    PlayerWin := PlayerTurn();
    if PlayerWin then
      Break;
    CPUWin := CPUTurn();
    if CPUWin then
      Break;
  until false;

  Console.ForegroundColor := TConsoleColor.Green;

  if PlayerWin then
    Console.WriteLine('Player win!')
  else
  begin
    Console.WriteLine('CPU win!');
    Console.WriteLine('If you wanna know, my number was {0}', [CPUNumber]);
  end;

  readln;
end.

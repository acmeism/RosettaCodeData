program Game21;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.StrUtils, // for IfThen
  Winapi.Windows;  // for ClearScreen

const
  HARD_MODE = True;

var
  computerPlayer: string = 'Computer';
  humanPlayer: string = 'Player 1';

  // for change color
  ConOut: THandle;
  BufInfo: TConsoleScreenBufferInfo;

procedure ClearScreen;
var
  stdout: THandle;
  csbi: TConsoleScreenBufferInfo;
  ConsoleSize: DWORD;
  NumWritten: DWORD;
  Origin: TCoord;
begin
  stdout := GetStdHandle(STD_OUTPUT_HANDLE);
  Win32Check(stdout <> INVALID_HANDLE_VALUE);
  Win32Check(GetConsoleScreenBufferInfo(stdout, csbi));
  ConsoleSize := csbi.dwSize.X * csbi.dwSize.Y;
  Origin.X := 0;
  Origin.Y := 0;
  Win32Check(FillConsoleOutputCharacter(stdout, ' ', ConsoleSize, Origin, NumWritten));
  Win32Check(FillConsoleOutputAttribute(stdout, csbi.wAttributes, ConsoleSize,
    Origin, NumWritten));
  Win32Check(SetConsoleCursorPosition(stdout, Origin));
end;

procedure ResetColor;
begin
  SetConsoleTextAttribute(ConOut, BufInfo.wAttributes);
end;

procedure ChangeColor(color: Word);
begin
  ConOut := TTextRec(Output).Handle;
  GetConsoleScreenBufferInfo(ConOut, BufInfo);
  SetConsoleTextAttribute(TTextRec(Output).Handle, color);
end;

function SwapPlayer(currentPlayer: string): string;
begin
  Result := IfThen(currentPlayer = humanPlayer, computerPlayer, humanPlayer);
end;

function RandomPlayerSelect(): string;
begin
  Result := IfThen(Random() < 0.5, computerPlayer, humanPlayer);
end;

function CheckIfCanWin(total: Integer): Boolean;
begin
  result := (total >= 18);
end;

function CheckIfCanLose(total: Integer; var choose: Integer; hardMode: Boolean =
  False): Boolean;
var
  range: Integer;
begin
  range := 17 - total;
  Result := false;
  if (range > 0) and (range < 4) then
  begin
    Result := true;
    if hardMode then
      choose := range
    else
      choose := Random(range - 1) + 1;
  end;
end;

function CompMove(total: Integer): Integer;
begin
  if (CheckIfCanWin(total)) then
  begin
    exit(21 - total);
  end;

  if CheckIfCanLose(total, Result, HARD_MODE) then
    exit;

  Result := Random(3) + 1;
end;

function HumanMove: Integer;
var
  choice: string;
begin
  repeat
    Writeln('Choose from numbers: 1, 2, 3');
    Readln(choice);
  until TryStrToInt(choice, Result) and (Result in [1..3]);
end;

procedure PlayGame();
var
  playAnother: Boolean;
  total, final_, roundChoice, compWins, humanWins: Integer;
  choice, currentPlayer: string;
begin
  playAnother := True;
  total := 0;
  final_ := 21;
  roundChoice := 0;
  Randomize;
  currentPlayer := RandomPLayerSelect();
  compWins := 0;
  humanWins := 0;

  while (playAnother) do
  begin
    ClearScreen;
    ChangeColor(FOREGROUND_INTENSITY or FOREGROUND_GREEN);
    Writeln(total);
    ResetColor;
    Writeln('');

    Writeln('Now playing: ' + currentPlayer);
    if currentPlayer = computerPlayer then
      roundChoice := CompMove(total)
    else
      roundChoice := HumanMove;
    inc(total, roundChoice);

    if (total = final_) then
    begin
      if (currentPlayer = computerPlayer) then
      begin
        inc(compWins);
      end
      else
      begin
        inc(humanWins);
      end;

      ClearScreen;
      Writeln('Winner: ' + currentPlayer);
      Writeln('Comp wins: ', compWins, '. Human wins: ', humanWins, #10);
      Writeln('Do you wan to play another round? y/n');

      readln(choice);

      if choice = 'y' then
      begin
        total := 0;
        ClearScreen;
      end
      else if choice = 'n' then
        playAnother := false
      else
      begin
        Writeln('Invalid choice! Choose from y or n');
        Continue;
      end;
    end
    else if total > 21 then
    begin
      Writeln('Not the right time to play this game :)');
      break;
    end;

    currentPlayer := SwapPlayer(currentPlayer);
  end;

end;

const
  WELLCOME_MSG: array[0..5] of string = ('Welcome to 21 game'#10,
    '21 is a two player game.', 'The game is played by choosing a number.',
    '1, 2, or 3 to be added a total sum.'#10,
    'The game is won by the player reaches exactly 21.'#10, 'Press ENTER to start!'#10);

var
  i: Integer;

begin
  try
    for i := 0 to High(WELLCOME_MSG) do
      Writeln(WELLCOME_MSG[i]);
    ResetColor;
    Readln; // Wait press enter

    PlayGame();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

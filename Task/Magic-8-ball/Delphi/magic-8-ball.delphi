program Magic_8_ball;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  windows;

// https://stackoverflow.com/questions/29794559/delphi-console-xe7-clearscreen
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

const
  answers: array[0..19] of string = ('It is certain.', 'It is decidedly so.',
    'Without a doubt.', 'Yes – definitely.', 'You may rely on it.',
    'As I see it, yes.', 'Most likely.', 'Outlook good.', 'Yes.',
    'Signs point to yes.', 'Reply hazy, try again.', 'Ask again later',
    'Better not tell you now.', 'Cannot predict now.',
    'Concentrate and ask again.', 'Don''t count on it.', 'My reply is no.',
    'My sources say no.', 'Outlook not so good.', 'Very doubtful.');

begin
  Randomize;
  while True do
  begin
    writeln('Magic 8 Ball! Ask question and hit ENTER key for the answer!');
    readln;
    ClearScreen;
    writeln(answers[Random(length(answers))], #10#10#10);
    writeln('(Hit ENTER key to ask again)');
    readln;
    ClearScreen;
  end;
end.

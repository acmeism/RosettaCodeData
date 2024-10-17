program Egyptian_division;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  System.Console; //https://github.com/JensBorrisholt/DelphiConsole

type
  TIntegerDynArray = TArray<Integer>;

  TIntegerDynArrayHelper = record helper for TIntegerDynArray
  public
    procedure Add(value: Integer);
  end;

procedure Divide(dividend, divisor: Integer);
var
  result, reminder, powers_of_two, doublings, answer, accumulator, two, pow, row: Integer;
  table_powers_of_two, table_doublings: TIntegerDynArray;
begin
  result := 0;
  reminder := 0;
  powers_of_two := 0;
  doublings := 0;
  answer := 0;
  accumulator := 0;
  two := 2;
  pow := 0;
  row := 0;

  writeln('                           ');
  writeln(' powers_of_2     doublings ');
  writeln('                           ');

  powers_of_two := 1;
  doublings := divisor;
  while doublings <= dividend do
  begin
    table_powers_of_two.Add(powers_of_two);

    table_doublings.Add(doublings);

    Writeln(Format('%8d %16d', [powers_of_two, doublings]));
    Inc(pow);
    powers_of_two := Trunc(IntPower(two, pow));
    doublings := powers_of_two * divisor;
  end;
  writeln('                           ');

  row := pow - 1;
  writeln('                                                 ');
  writeln(' powers_of_2     doublings   answer   accumulator');
  writeln('                                                 ');
  Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop + row);
  Dec(pow);
  while (pow >= 0) and (accumulator < dividend) do
  begin

    doublings := Trunc(table_doublings[pow]);
    powers_of_two := Trunc(table_powers_of_two[pow]);
    if (accumulator + Trunc(table_doublings[pow])) <= dividend then
    begin

      accumulator := accumulator + doublings;
      answer := answer + powers_of_two;

      Console.ForegroundColor := TConsoleColor.Green;
      Write(Format('%8d %16d', [powers_of_two, doublings]));
      Console.ForegroundColor := TConsoleColor.Green;
      writeln(format('%10d %12d', [answer, accumulator]));
      Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop - 2);
    end
    else
    begin

      Console.ForegroundColor := TConsoleColor.DarkGray;
      Write(Format('%8d %16d', [powers_of_two, doublings]));
      Console.ForegroundColor := TConsoleColor.Gray;
      writeln(format('%10d %12d', [answer, accumulator]));
      Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop - 2);
    end;
    Dec(pow);
  end;
  writeln;
  Console.SetCursorPosition(Console.CursorLeft, Console.CursorTop + row + 2);
  Console.ResetColor();

  result := answer;
  if accumulator < dividend then
  begin
    reminder := dividend - accumulator;
    Console.WriteLine(' So ' + dividend.ToString + ' divided by ' + divisor.ToString
      + ' using the Egyptian method is '#10' ' + result.ToString +
      ' remainder (' + dividend.ToString + ' - ' + accumulator.ToString +
      ') or ' + reminder.ToString);
    writeln;
  end
  else
  begin
    reminder := 0;
    Console.WriteLine(' So ' + dividend.ToString + ' divided by ' + divisor.ToString
      + ' using the Egyptian method is '#10' ' + result.ToString + ' remainder '
      + reminder.ToString);
    writeln;
  end;
end;

{ TIntegerDynArrayHelper }

procedure TIntegerDynArrayHelper.Add(value: Integer);
begin
  SetLength(self, length(self) + 1);
  Self[high(self)] := value;
end;

function parseInt(s: string): Integer;
var
  c: Char;
  s2: string;
begin
  s2 := '';
  for c in s do
  begin
    if c in ['0'..'9'] then
      s2 := s2 + c;

  end;
  result := s2.ToInteger();
end;

var
  dividend, divisor: Integer;

begin
  Console.Clear();
  writeln;
  writeln(' Egyptian division ');
  writeln;
  Console.Write(' Enter value of dividend : ');
  dividend := parseInt(Console.ReadLine());
  Console.Write(' Enter value of divisor : ');
  divisor := parseInt(Console.ReadLine());
  Divide(dividend, divisor);
  writeln;
  Console.Write('Press any key to continue . . . ');
  Console.ReadKey(true);
end.

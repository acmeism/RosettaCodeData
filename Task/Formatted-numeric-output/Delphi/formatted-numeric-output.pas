program FormattedNumericOutput;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  fVal = 7.125;

begin
  Writeln(FormatFloat('0000#.000',fVal));
  Writeln(FormatFloat('0000#.0000000',fVal));
  Writeln(FormatFloat('##.0000000',fVal));
  Writeln(FormatFloat('0',fVal));
  Writeln(FormatFloat('#.#E-0',fVal));
  Writeln(FormatFloat('#,##0.00;;Zero',fVal));
  Readln;
end.

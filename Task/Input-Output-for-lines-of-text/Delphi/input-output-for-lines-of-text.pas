program Output_for_Lines_of_Text;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function QueryIntNumber(): Integer;
var
  val: string;
begin
  Result := 0;
  repeat
    Writeln('Digite a number(Enter to confirm):');
    Readln(val);

    if not TryStrToInt(val, Result) then
    begin
      Writeln('"', val, '" is not a valid number.');
      Continue;
    end;
    if Result <= 0 then
    begin
      Writeln('"', val, '" must be greater then 0');
      Continue;
    end;
  until Result > 0;
end;

var
  n_lines, i: integer;
  lines, line: string;

begin
  lines := '';
  n_lines := QueryIntNumber;

  for i := 1 to n_lines do
  begin
    Readln(line);
    if i > 1 then
      lines := lines + #10;
    lines := lines + line;
  end;

  Writeln(lines);
  Readln;
end.

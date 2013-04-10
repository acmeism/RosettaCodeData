program isNumeric;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils;

function IsNumericString(const inStr: string): Boolean;
var
  i: extended;
begin
  Result := TryStrToFloat(inStr,i);
end;


{ Test function }
var
  s: string;
  c: Integer;

const
  MAX_TRIES = 10;
  sPROMPT   = 'Enter a string (or type "quit" to exit):';
  sIS       = ' is numeric';
  sISNOT    = ' is NOT numeric';

begin
  c := 0;
  s := '';
  repeat
    Inc(c);
    Writeln(sPROMPT);
    Readln(s);
    if (s <> '') then
      begin
        tmp.Add(s);
        if IsNumericString(s) then
          begin
            Writeln(s+sIS);
          end
          else
          begin
            Writeln(s+sISNOT);
          end;
        Writeln('');
      end;
  until
    (c >= MAX_TRIES) or (LowerCase(s) = 'quit');

end.

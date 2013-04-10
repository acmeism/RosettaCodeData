program EmptyString;

{$APPTYPE CONSOLE}

uses SysUtils;

function StringIsEmpty(const aString: string): Boolean;
begin
  Result := aString = '';
end;

var
  s: string;
begin
  s := '';
  Writeln(StringIsEmpty(s)); // True

  s := 'abc';
  Writeln(StringIsEmpty(s)); // False
end.

program String_append;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TStringHelper = record helper for string
    procedure Append(str: string);
  end;

{ TStringHelper }

procedure TStringHelper.Append(str: string);
begin
  Self := self + str;
end;

begin
  var h: string;

  // with + operator
  h := 'Hello';
  h := h + ' World';
  writeln(h);

  // with a function concat
  h := 'Hello';
  h := Concat(h, ' World');
  writeln(h);

  // with helper
  h := 'Hello';
  h.Append(' World');
  writeln(h);
  readln;
end.

program String_preappend;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TStringHelper = record helper for string
    procedure Preappend(str: string);
  end;

{ TStringHelper }

procedure TStringHelper.Preappend(str: string);
begin
  Self := str + self;
end;

begin
  var h: string;

  // with + operator
  h := 'World';
  h := 'Hello ' + h;
  writeln(h);

  // with a function concat
  h := 'World';
  h := concat('Hello ', h);
  writeln(h);

  // with helper
  h := 'World';
  h.Preappend('Hello ');
  writeln(h);
  readln;
end.

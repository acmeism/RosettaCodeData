program ExceptionsInNestedCall;

{$APPTYPE CONSOLE}

uses SysUtils;

type
  U0 = class(Exception)
  end;
  U1 = class(Exception)
  end;

procedure Baz(i: Integer);
begin
  if i = 0 then
    raise U0.Create('U0 Error message')
  else
    raise U1.Create('U1 Error message');
end;

procedure Bar(i: Integer);
begin
  Baz(i);
end;

procedure Foo;
var
  i: Integer;
begin
  for i := 0 to 1 do
  begin
    try
      Bar(i);
    except
      on E: U0 do
        Writeln('Exception ' + E.ClassName + ' caught');
    end;
  end;
end;

begin
  Foo;
end.

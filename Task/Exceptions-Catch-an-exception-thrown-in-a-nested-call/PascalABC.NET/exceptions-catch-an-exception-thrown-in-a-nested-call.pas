type
  U0 = class (Exception) end;
  U1 = class (Exception) end;

procedure baz(i: integer);
begin
  if (i = 0) then raise new U0
  else
    raise new U1;
end;

procedure bar(i: integer) :=  baz(i);

procedure foo;
begin
  for var i := 0 to 1 do
    try
      bar(i);
    except
      on U0 do Writeln('U0 Caught');
    end;
end;

begin
  foo;
end.

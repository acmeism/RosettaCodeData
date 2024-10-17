var
	i: integer;
	p: ^integer;
begin
	p := @i;
	writeLn(p^);
end;

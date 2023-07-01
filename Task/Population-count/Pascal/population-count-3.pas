var
	i: integer;
	f: set of 0..(bitSizeOf(i)-1) absolute i; // same address as i, but different interpretation
begin
	writeLn(card(f));
end;

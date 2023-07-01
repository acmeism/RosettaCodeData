Program OneHundredDoors;

var
   doors : Array[1..100] of Boolean;
   i, j	 : Integer;

begin
   for i := 1 to 100 do
      doors[i] := False;
   for i := 1 to 100 do begin
      j := i;
      while j <= 100 do begin
	 doors[j] := not doors[j];
	 j := j + i
      end
   end;
   for i := 1 to 100 do begin
      Write(i, ' ');
      if doors[i] then
	 WriteLn('open')
      else
	 WriteLn('closed');
   end
end.

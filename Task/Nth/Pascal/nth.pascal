Program n_th;

function Suffix(N: NativeInt):AnsiString;
var
  res: AnsiString;
begin
  res:= 'th';
  case N mod 10 of
  1:IF N mod 100 <> 11 then
      res:= 'st';
  2:IF N mod 100 <> 12 then
      res:= 'nd';
  3:IF N mod 100 <> 13 then
      res:= 'rd';
  else
  end;
  Suffix := res;
end;

procedure Print_Images(loLim, HiLim: NativeInt);
var
  i : NativeUint;
begin
  for I := LoLim to HiLim do
    write(i,Suffix(i),' ');
  writeln;
end;

begin
   Print_Images(   0,   25);
   Print_Images( 250,  265);
   Print_Images(1000, 1025);
end.

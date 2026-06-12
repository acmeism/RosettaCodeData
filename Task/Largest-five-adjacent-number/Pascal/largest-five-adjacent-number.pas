var
  digits,
  s : AnsiString;
  i : LongInt;
begin
  randomize;
  setlength(digits,1000);
  for i := 1 to 1000 do
    digits[i] := chr(random(10)+ord('0'));
  for i := 99999 downto 0 do
  begin
    str(i:5,s);
    if Pos(s,digits) > 0 then
      break;
  end;
  writeln(s, ' found as largest 5 digit number ')
end.

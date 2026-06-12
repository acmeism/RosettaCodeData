Program abcwords;
uses Classes, sysutils;
const
  FNAME = 'unixdict.txt';

var
  list: TStringList;
  str : string;
  a,b,c: integer;
  ch : char;


begin
  list := TStringList.Create;
  list.LoadFromFile(FNAME);
  for str in list do
  begin
    a := 0; b := 0; c := 0;
    for ch in str do
    begin
      if (ch = 'a') or (ch = 'A') then inc(a) else
      if (ch = 'b') or (ch = 'B') then inc(b) else
      if (ch = 'c') or (ch = 'C') then inc(c);
    end;
    if (a > 0) and (a=b) and (a=c) then writeln(str);
  end;
end.

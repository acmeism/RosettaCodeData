Program abcwords;
uses Classes;

const
  FNAME = 'unixdict.txt';

var
  list: TStringList;
  str : string;
  a,b,c : integer;


begin
  list := TStringList.Create;
  list.LoadFromFile(FNAME);
  for str in list do
  begin
    a := pos('a',str);
    b := pos('b',str);
    c := pos('c',str);
    if (a>0) and (b>a) and (c > b) then writeln(str);
   end;
end.

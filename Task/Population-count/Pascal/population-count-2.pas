program pcntTest;
uses
  sysutils,popCount;

function Odious(n:Uint32):boolean;inline;
Begin
  Odious := boolean(PopCnt(n) AND 1)
end;

function EvilNumber(n:Uint32):boolean;inline;
begin
  EvilNumber := boolean(NOT(PopCnt(n)) AND 1);
end;

var
  s : String;
  i : Uint64;
  k : LongWord;
Begin
  s :='PopCnt 3^i     :';
  i:= 1;
  For k := 1 to 30 do
  Begin
    s := s+InttoStr(PopCnt(i)) +' ';
    i := 3*i;
  end;
  writeln(s);writeln;

  s:='Evil numbers   :';i := 0;k := 0;
  repeat
    IF EvilNumber(i) then
    Begin
      inc(k);s := s+InttoStr(i) +' ';
    end;
    inc(i);
  until k = 30;
  writeln(s);writeln;s:='';


  s:='Odious numbers :';i := 0;k := 0;
  repeat
    IF Odious(i) then
    Begin
      inc(k);s := s+InttoStr(i) +' ';
    end;
    inc(i);
  until k = 30;
  writeln(s);
end.

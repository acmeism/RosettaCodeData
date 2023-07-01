program Spiralmat;
type
  tDir = (left,down,right,up);
  tdxy = record
           dx,dy: longint;
         end;
  tdeltaDir = array[tDir] of tdxy;
const
  Nextdir : array[tDir] of tDir = (down,right,up,left);
  cDir : tDeltaDir = ((dx:1;dy:0),(dx:0;dy:1),(dx:-1;dy:0),(dx:0;dy:-1));
  cMaxN = 32;
type
  tSpiral =  array[0..cMaxN,0..cMaxN] of LongInt;

function FillSpiral(n:longint):tSpiral;
var
  b,i,k, dn,x,y : longInt;
  dir : tDir;
  tmpSp : tSpiral;
BEGIN
  b := 0;
  x := 0;
  y := 0;
  //only for the first line
  k := -1;
  dn := n-1;
  tmpSp[x,y] := b;
  dir :=  left;
  repeat
    i := 0;
    while i < dn do
    begin
      inc(b);
      tmpSp[x,y] := b;
      inc(x,cDir[dir].dx);
      inc(y,cDir[dir].dy);
      inc(i);
    end;
    Dir:= NextDir[dir];
    inc(k);
    IF k > 1 then
    begin
      k := 0;
      //shorten the line every second direction change
      dn := dn-1;
      if dn <= 0 then
        BREAK;
    end;
  until false;
  //the last
  tmpSp[x,y] := b+1;
  FillSpiral := tmpSp;
end;

var
  a : tSpiral;
  x,y,n : LongInt;
BEGIN
  For n := 1 to 5{cMaxN} do
  begin
    A:=FillSpiral(n);
    For y := 0 to n-1 do
    begin
      For x := 0 to n-1 do
        write(A[x,y]:4);
      writeln;
    end;
    writeln;
  end;
END.

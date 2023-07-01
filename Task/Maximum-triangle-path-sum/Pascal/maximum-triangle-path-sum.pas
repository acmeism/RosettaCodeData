program TriSum;
{'triangle.txt'
* one element per line
55
94
48
95
30
96
...}
const
 cMaxTriHeight = 18;
 cMaxTriElemCnt = (cMaxTriHeight+1)*cMaxTriHeight DIV 2 +1;
type
  tElem = longint;
  tbaseRow =  array[0..cMaxTriHeight] of tElem;
  tmyTri   =  array[0..cMaxTriElemCnt] of tElem;

function ReadTri(     fname:string;
                  out     t:tmyTri):integer;
{read triangle values into t and returns height}
var
  f : text;
  s : string;
  i : integer;
  ValCode : word;
begin
  i := 0;
  fillchar(t,Sizeof(t),#0);

  Assign(f,fname);
  {$I-}
  reset(f);
  IF ioResult <> 0 then
  begin
    writeln('IO-Error ',ioResult);
    close(f);
    ReadTri := i;
    EXIT;
  end;
  {$I+}

  while NOT(EOF(f)) AND (i<cMaxTriElemCnt) do
  begin
    readln(f,s);
    val(s,t[i],ValCode);
    inc(i);
    IF ValCode <> 0 then
    begin
      writeln(ValCode,' conversion error at line ',i);
      fillchar(t,Sizeof(t),#0);
      i := 0;
      BREAK;
    end;
  end;
  close(f);
  ReadTri := round(sqrt(2*(i-1)));
end;

function TriMaxSum(var t: tmyTri;hei:integer):integer;
{sums up higher values bottom to top}
var
  i,r,h,tmpMax : integer;
  idxN : integer;
  sumrow : tbaseRow;
begin
  h := hei;
  idxN := (h*(h+1)) div 2 -1;
  {copy base row}
  move(t[idxN-h+1],sumrow[0],SizeOf(tElem)*h);
  dec(h);
{  for r := 0 to h do write(sumrow[r]:4);writeln;}
  idxN := idxN-h;
  while idxN >0 do
  begin
    i := idxN-h;
    r := 0;
    while r < h do
    begin
      tmpMax:= sumrow[r];
      IF tmpMax<sumrow[r+1] then
        tmpMax:=sumrow[r+1];
      sumrow[r]:= tmpMax+t[i];
      inc(i);
      inc(r);
    end;
    idxN := idxN-h;
    dec(h);
{  for r := 0 to h do write(sumrow[r]:4);writeln;}
  end;
  TriMaxSum := sumrow[0];
end;

var
  h : integer;
  triangle : tmyTri;
Begin
{  writeln(TriMaxSum(triangle,ReadTri('triangle.txt',triangle))); -> 1320}
  h := ReadTri('triangle.txt',triangle);
  writeln('height sum');
  while h > 0 do
  begin
    writeln(h:4,TriMaxSum(triangle,h):7);
    dec(h);
  end;
end.

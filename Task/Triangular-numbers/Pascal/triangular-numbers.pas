program XangularNumbers;
const
  MAXIDX = 29;
  MAXLINECNT = 13;
  cNames : array[0..4] of string =
     ('','','triangular','tetrahedral','pentatopic');
  cCheckRootValues :array[0..3] of Uint64 =
       (7140,21408696,26728085384,14545501785001)   ;
type
  tOneLine  = array[0..MAXIDX+2] of Uint64;
  tpOneLine = ^tOneLine;
  tSimplexs  = array[0..MAXLINECNT-1] of tOneLine;

procedure OutLine(var S:tSimplexs;idx: NativeInt);
const
  cColCnt = 6;cColWidth = 80 DIV cColCnt;
var
  i,colcnt : NativeInt;
begin
  if idx > High(cNames) then
    writeln('First ',MAXIDX+1,' ',idx,'-simplex numbers')
  else
    writeln('First ',MAXIDX+1,' ',cNames[idx],' numbers');
  colcnt := cColCnt;
  For i := 0 to MAXIDX do
  begin
    write(S[idx,i]:cColWidth);
    dec(colCnt);
    if ColCnt = 0 then
    Begin
      writeln;
      ColCnt := cColCnt;
    end;
  end;
  if ColCnt <  cColCnt then
    writeln;
  writeln;
end;

procedure CalcNextLine(var S:tSimplexs;idx: NativeInt);
var
  s1,s2: Uint64;
  i : NativeInt;
begin
  s1 := S[idx,0];
  S[idx+1,0] := s1;
  For i := 1 to MAXIDX do
  begin
    s2:= S[idx,i];
    S[idx+1,i] := s1+s2;
    inc(s1,s2);
  end;
end;

procedure InitSimplexs(var S:tSimplexs);
var
  i: NativeInt;
begin
  fillChar(S,Sizeof(S),#0);
  For i := 1 to MAXIDX do
    S[0,i] := 1;
  For i := 0 to MAXLINECNT-2 do
    CalcNextLine(S,i);
end;

function TriangularRoot(n: Uint64): extended;
begin
  if n < High(Uint64) DIV 8 then
    TriangularRoot := (sqrt(8*n+1)-1) / 2
  else
    TriangularRoot := (sqrt(8)*sqrt(n)-1)/2;
end;

function tetrahedralRoot(n: Uint64): extended;
const
  cRec27 = 1/sqrt(27);
var
  x,y : extended;
begin
  y := 3.0*n;
  x := sqrt((y-cRec27)*(y+cRec27));//sqrt(sqr(3*n)-1/27)
  if x < y then
    tetrahedralRoot := exp(ln(y+x)/3.0)+exp(ln(y-x)/3.0)-1.0
  else
    //( 6*n)^(1/3)-1
    tetrahedralRoot :=exp(ln(6)/3.0)*exp(ln(n)/3.0)-1.0; //6^(1/3)* n^(1/3)-1
end;

function PentatopicRoot(n: Uint64): extended;
begin
  PentatopicRoot := (sqrt(5 + 4 * sqrt(24*n + 1)) - 3) / 2;
end;

var
  Simplexs  : tSimplexs;
  n : Uint64;
  i : NativeInt;
Begin
  InitSimplexs(Simplexs);
  OutLine(Simplexs,2);
  OutLine(Simplexs,3);
  OutLine(Simplexs,4);
  OutLine(Simplexs,12);
  For i := 0 to High(cCheckRootValues) do
  begin
    n := cCheckRootValues[i];
    writeln('Roots of ',n,':');
    writeln('triangular -root : ',TriangularRoot(n):20:12);
    writeln('tetrahedral-root : ',tetrahedralRoot(n):20:12);
    writeln('pentatopic -root : ',PentatopicRoot(n):20:12);
    writeln;
  end;
end.

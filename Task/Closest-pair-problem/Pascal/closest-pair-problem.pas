program closestPoints;
{$IFDEF FPC}
   {$MODE Delphi}
{$ENDIF}
const
  PointCnt = 10000;//31623;
type
  TdblPoint = Record
               ptX,
               ptY : double;
              end;
  tPtLst =  array of TdblPoint;

  tMinDIstIdx  = record
                   md1,
                   md2 : NativeInt;
                 end;

function ClosPointBruteForce(var  ptl :tPtLst):tMinDIstIdx;
Var
  i,j,k : NativeInt;
  mindst2,dst2: double; //square of distance, no need to sqrt
  p0,p1 : ^TdblPoint;   //using pointer, since calc of ptl[?] takes much time
Begin
  i := Low(ptl);
  j := High(ptl);
  result.md1 := i;result.md2 := j;
  mindst2 := sqr(ptl[i].ptX-ptl[j].ptX)+sqr(ptl[i].ptY-ptl[j].ptY);
  repeat
    p0 := @ptl[i];
    p1 := p0; inc(p1);
    For k := i+1 to j do
    Begin
      dst2:= sqr(p0^.ptX-p1^.ptX)+sqr(p0^.ptY-p1^.ptY);
      IF mindst2 > dst2  then
      Begin
        mindst2 :=  dst2;
        result.md1 := i;
        result.md2 := k;
      end;
      inc(p1);
    end;
    inc(i);
  until i = j;
end;

var
  PointLst :tPtLst;
  cloPt : tMinDIstIdx;
  i : NativeInt;
Begin
  randomize;
  setlength(PointLst,PointCnt);
  For i := 0 to PointCnt-1 do
    with PointLst[i] do
    Begin
      ptX := random;
      ptY := random;
    end;
  cloPt:=  ClosPointBruteForce(PointLst) ;
  i := cloPt.md1;
  Writeln('P[',i:4,']= x: ',PointLst[i].ptX:0:8,
                     ' y: ',PointLst[i].ptY:0:8);
  i := cloPt.md2;
  Writeln('P[',i:4,']= x: ',PointLst[i].ptX:0:8,
                     ' y: ',PointLst[i].ptY:0:8);
end.

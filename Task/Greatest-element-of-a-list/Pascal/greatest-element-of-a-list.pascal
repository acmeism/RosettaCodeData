program GElemLIst;
{$IFNDEF FPC}
  {$Apptype Console}
{$else}
  {$Mode Delphi}
{$ENDIF}

uses
  sysutils;
const
  MaxCnt = 1000000;
type
   tMaxIntPos= record
                  mpMax,
                  mpPos : integer;
                end;
   tMaxfltPos= record
                  mpMax : double;
                  mpPos : integer;
                end;


function FindMaxInt(const ia: array of integer):tMaxIntPos;
//delivers the highest Element and position of integer array
var
  i  : NativeInt;
  tmp,max,ps: integer;
Begin
  max := -MaxInt-1;
  ps := -1;
  //i = index of last Element
  i := length(ia)-1;
  IF i>=0 then Begin
    max := ia[i];
    ps := i;
    dec(i);
    while i> 0 do begin
      tmp := ia[i];
      IF max< tmp then begin
        max := tmp;
        ps := i;
        end;
      dec(i);
      end;
    end;
  result.mpMax := Max;
  result.mpPos := ps;
end;

function FindMaxflt(const ia: array of double):tMaxfltPos;
//delivers the highest Element and position of double array
var
  i,
  ps: NativeInt;
  max : double;
  tmp : ^double;//for 32-bit version runs faster

Begin
  max := -MaxInt-1;
  ps := -1;
  //i = index of last Element
  i := length(ia)-1;
  IF i>=0 then Begin
    max := ia[i];
    ps := i;
    dec(i);
    tmp := @ia[i];
    while i> 0 do begin
      IF tmp^>max  then begin
        max := tmp^;
        ps := i;
        end;
      dec(i);
      dec(tmp);
      end;
    end;
  result.mpMax := Max;
  result.mpPos := ps;
end;

var
  IntArr : array of integer;
  fltArr : array of double;
  ErgInt : tMaxINtPos;
  ErgFlt : tMaxfltPos;
  i: NativeInt;
begin
  randomize;
  setlength(fltArr,MaxCnt); //filled with 0
  setlength(IntArr,MaxCnt); //filled with 0.0
  For i := High(fltArr) downto 0 do
    fltArr[i] := MaxCnt*random();
  For i := High(IntArr) downto 0 do
    IntArr[i] := round(fltArr[i]);

  ErgInt := FindMaxInt(IntArr);
  writeln('FindMaxInt ',ErgInt.mpMax,' @ ',ErgInt.mpPos);

  Ergflt := FindMaxflt(fltArr);
  writeln('FindMaxFlt ',Ergflt.mpMax:0:4,' @ ',Ergflt.mpPos);
end.

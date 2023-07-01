program pythQuad_2;
//find phythagorean Quadrupel up to a,b,c,d <= 2200
//a^2 + b^2 +c^2 = d^2
//a^2 + b^2 = d^2-c^2
{$IFDEF FPC}
  {$R+,O+} //debug purposes, not slower
  {$OPTIMIZATION ON,ALL}
  {$CODEALIGN proc=16}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}
uses
   sysutils;
const
   MaxFactor = 2200;//22000;//40960;
   limit = MaxFactor*MaxFactor;
type
   tIdx = NativeUint;
   tSum = NativeUint;
var
// global variables are initiated with 0 at startUp
   sumA2B2 :array[0..limit] of byte;
   check :  array[0..MaxFactor] of byte;

procedure BuildSumA2B2;
var
   a,b,a2,Uplmt: tIdx;
begin
  //Uplimt = a*a+b*b < Maxfactor | max(a,b) = Uplmt
  Uplmt := Trunc(MaxFactor*sqrt(0.5));
  For a := 1 to Uplmt  do
  Begin
    a2:= a*a;
    For b := a downto 1 do
      sumA2B2[b*b+a2] := 1
  end;
end;

procedure CheckDifD2C2;
var
  d,d2,c : tIdx;
begin
  For d := 1 to MaxFactor do
  Begin
    //c < d => (d*d-c*c) > 0
    d2 := d*d;
    For c := d-1 downto 1 do
    Begin
      // d*d-c*c == (d+c)*(d-c) nonsense
      if sumA2B2[d2-c*c] <> 0 then
      Begin
        Check[d] := 1;
        //first for d found is enough
        BREAK;
      end;
    end;
  end;
end;

var
  i : NativeUint;
begin
  BuildSumA2B2;
  CheckDifD2C2;
  //FindHoles
  For i := 1 to MaxFactor do
    If Check[i] = 0  then
      write(i,' ');
  writeln;
end.

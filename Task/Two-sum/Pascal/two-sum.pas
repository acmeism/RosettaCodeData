program twosum;
{$IFDEF FPC}{$MODE DELPHI}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
type
  tSolRec = record
              SolRecI,
              SolRecJ : NativeInt;
            end;
  tMyArray = array of NativeInt;
const
// just a gag using unusual index limits
  ConstArray :array[-17..-13] of NativeInt = (0, 2, 11, 19, 90);

function Check2SumUnSorted(const A  :tMyArray;
                                 sum:NativeInt;
                           var   Sol:tSolRec):boolean;
//Check every possible sum A[max] + A[max-1..0]
//than A[max-1] + A[max-2..0] etc pp.
//quadratic runtime: maximal  (max-1)*max/ 2 checks
//High(A) always checked for dynamic array, even const
//therefore run High(A) to low(A), which is always 0 for dynamic array
label
  SolFound;
var
  i,j,tmpSum: NativeInt;
Begin
  Sol.SolRecI:=0;
  Sol.SolRecJ:=0;
  i := High(A);
  while i > low(A) do
  Begin
    tmpSum := sum-A[i];
    j := i-1;
    while j >= low(A) do
    begin
      //Goto is bad, but fast...
      if tmpSum = a[j] Then
        GOTO SolFound;
      dec(j);
    end;
    dec(i);
  end;
  result := false;
  exit;
SolFound:
  Sol.SolRecI:=j;Sol.SolRecJ:=i;
  result := true;
end;

function Check2SumSorted(const  A  :tMyArray;
                                sum:NativeInt;
                         var    Sol:tSolRec):boolean;
var
  i,j,tmpSum: NativeInt;
Begin
  Sol.SolRecI:=0;
  Sol.SolRecJ:=0;
  i := low(A);
  j := High(A);
  while(i < j) do
  Begin
    tmpSum := a[i] + a[j];
    if tmpSum = sum then
    Begin
      Sol.SolRecI:=i;Sol.SolRecJ:=j;
      result := true;
      EXIT;
    end;
    if tmpSum < sum then
    begin
      inc(i);
      continue;
    end;
    //if tmpSum > sum then
    dec(j);
  end;
  writeln(i:10,j:10);
  result := false;
end;

var
  Sol :tSolRec;
  CheckArr : tMyArray;
  MySum,i : NativeInt;

Begin
  randomize;
  setlength(CheckArr,High(ConstArray)-Low(ConstArray)+1);
  For i := High(CheckArr) downto low(CheckArr) do
    CheckArr[i] := ConstArray[i+low(ConstArray)];

  MySum  := 21;
  IF Check2SumSorted(CheckArr,MySum,Sol) then
    writeln('[',Sol.SolRecI,',',Sol.SolRecJ,'] sum to ',MySum)
  else
    writeln('No solution found');

  //now test a bigger sorted array..
  setlength(CheckArr,83667);
  For i := High(CheckArr) downto 0 do
    CheckArr[i] := i;
  MySum := CheckArr[Low(CheckArr)]+CheckArr[Low(CheckArr)+1];
  writeln(#13#10,'Now checking array of ',length(CheckArr),
          ' elements',#13#10);
  //runtime about 1 second
  IF Check2SumUnSorted(CheckArr,MySum,Sol) then
    writeln('[',Sol.SolRecI,',',Sol.SolRecJ,'] sum to ',MySum)
  else
    writeln('No solution found');
  //runtime not measurable
  IF Check2SumSorted(CheckArr,MySum,Sol) then
    writeln('[',Sol.SolRecI,',',Sol.SolRecJ,'] sum to ',MySum)
  else
    writeln('No solution found');
end.

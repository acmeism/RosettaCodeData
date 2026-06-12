program Coins0_1;
{$IFDEF FPC}
   {$MODE DELPHI}
   {$OPTIMIZATION ON,ALL}
{$ELSE}
  {$Apptype console}
{$ENDIF}

uses
  sysutils;// TDatetime
const
  coins1 :array[0..4] of byte = (1, 2, 3, 4, 5);
  coins2 :array[0..6] of byte = (1, 1, 2, 3, 3, 4, 5);
  coins3 :array[0..15] of byte = (1,2,3,4,5,5,5,5,15,15,10,10,10,10,25,100);
  nmax = High(Coins3);
type
{$IFNDEF FPC}
  NativeInt = Int32;
{$ENDIF}
  tFreeCol = array[0..nmax] of Int32;
var
  FreeIdx,
  IdxWeight : tFreeCol;
  n,
  gblCount : nativeUInt;

procedure AddNextWeight(Row,sum:nativeInt);
//order is important
var
  i,Col,Weight : nativeInt;
begin
  IF row <= n then
  begin
    For i := row to n do
    begin
      Col := FreeIdx[i];
      Weight:= IdxWeight[col];
      IF Sum+Weight <= 0 then
      Begin
        Sum +=Weight;
        If Sum = 0 then
        Begin
          Sum -=Weight;
          inc(gblCount);
        end
        else
        begin
          FreeIdx[i] := FreeIdx[Row];
          FreeIdx[Row] := Col;

          AddNextWeight(Row+1,sum);
          //Undo
          Sum -=Weight;
          FreeIdx[Row] := FreeIdx[i];
          FreeIdx[i] := Col;
        end;
      end;
    end;
  end;
end;

procedure CheckBinary(n,MaxIdx,Sum:NativeInt);
//order is not important
Begin
  if sum = 0 then
    inc(gblcount);
  If (sum < 0) AND (n <= MaxIdx) then
  Begin
    //test next sum
    CheckBinary(n+1,MaxIdx,Sum);// add nothing
    CheckBinary(n+1,MaxIdx,Sum+IdxWeight[n]);//or the actual index
  end;
end;

procedure CheckAll(i,MaxSum:NativeInt);
Begin
  n := i;
  gblCount := 0;
  AddNextWeight(0,-MaxSum);
  Write(MaxSum:6,gblCount:12);
  gblCount := 0;
  CheckBinary(0,i,-MaxSum);
  WriteLn(gblCount:12);
end;

var
  i: nativeInt;

begin
  writeln('sum':6,'very silly':12,'silly':12);
  For i := 0 to High(coins1) do
  Begin
    FreeIdx[i] := i;
    IdxWeight[i] := coins1[i];
  end;
  CheckAll(High(coins1),6);

  For i := 0 to High(coins2) do
  Begin
    FreeIdx[i] := i;
    IdxWeight[i] := coins2[i];
  end;
  CheckAll(High(coins2),6);

  For i := 0 to High(coins3) do
  Begin
    FreeIdx[i] := i;
    IdxWeight[i] := coins3[i];
  end;
  CheckAll(High(coins3),40);
end.

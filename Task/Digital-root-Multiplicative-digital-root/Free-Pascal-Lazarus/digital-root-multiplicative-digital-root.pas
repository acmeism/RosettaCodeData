program MultRoot;
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=16}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
type
  tMul3Dgt = array[0..999] of Uint32;
  tMulRoot = record
               mrNum,
               mrMul,
               mrPers : Uint64;
             end;
const
  Testnumbers : array[0..16] of Uint64 =(123321,7739,893,899998,
                                        18446743999999999999,
    //first occurence of persistence 0..11
                                    0,10,25,39,77,679, 6788, 68889, 2677889,
                                        26888999, 3778888999, 277777788888899);

var
  Mul3Dgt : tMul3Dgt;

procedure InitMulDgt;
var
  i,j,k,l : Int32;
begin
  l := 999;
  For i := 9 downto 0 do
    For j := 9 downto 0 do
      For k := 9 downto 0 do
      Begin
        Mul3Dgt[l] := i*j*k;
        dec(l);
      end;
end;

function GetMulDigits(n:Uint64):UInt64;inline;
var
  pMul3Dgt :^tMul3Dgt;
  q :Uint64;
begin
  pMul3Dgt := @Mul3Dgt[0];
  result := 1;
  while n >= 1000 do
  begin
    q := n div 1000;
    result *= pMul3Dgt^[n-1000*q];
    n := q;
  end;
  If n>=100 then
    result *= pMul3Dgt^[n]
  else
    if n>=10 then
       result *= pMul3Dgt^[n+100]
    else
      result *= n;//Mul3Dgt[n+110]
end;

procedure GetMulRoot(var MulRoot:tMulRoot);
var
  mr,
  pers : UInt64;
Begin
  pers := 0;
  mr := MulRoot.mrNum;
  while mr >=10 do
  Begin
    mr := GetMulDigits(mr);
    inc(pers);
  end;
  MulRoot.mrMul:= mr;
  MulRoot.mrPers:= pers;
end;

const
  MaxDgtCount = 9;
var
  //all initiated with 0
  MulRoot:tMulRoot;
  Sol    : array[0..9,0..MaxDgtCount-1] of tMulRoot;
  SolIds : array[0..9] of Int32;
  i,idx,mr,AlreadyDone : Int32;

BEGIN
  InitMulDgt;

  AlreadyDone := 10;//0..9
  MulRoot.mrNum := 0;
  repeat
    GetMulRoot(MulRoot);
    mr := MulRoot.mrMul;
    idx := SolIds[mr];
    If idx<MaxDgtCount then
    begin
      Sol[mr,idx]:= MulRoot;
      inc(idx);
      SolIds[mr]:= idx;
      if idx =MaxDgtCount then
        dec(AlreadyDone);
    end;
    inc(MulRoot.mrNum);
  until AlreadyDone = 0;
  writeln('MDR: First');
  For i := 0 to 9 do
  begin
    write(i:3,':');
    For idx := 0 to MaxDgtCount-1 do
      write(Sol[i,idx].mrNum:MaxDgtCount+1);
    writeln;
  end;
  writeln;
  writeln('number':20,' mulroot   persitance');
  For i := 0 to High(Testnumbers) do
  begin
    MulRoot.mrNum := Testnumbers[i];
    GetMulRoot(MulRoot);
    With MulRoot do
      writeln(mrNum:20,mrMul:8,mrPers:8);
  end;
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
END.

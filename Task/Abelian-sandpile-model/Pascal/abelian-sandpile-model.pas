program Abelian2;
{$IFDEF FPC}
   {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=16}{$ALIGN 16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils;

type
  Tlimit = record
             lmtLow,LmtHigh : LongWord;
           end;
  TRowlimits = array of Tlimit;
  tOneRow  = pLongWord;
  tGrid = array of LongWord;

var
  Grid: tGrid;
  Rowlimits:TRowlimits;
  s : AnsiString;
  maxval,maxCoor : NativeUint;

function CalcMaxCoor(maxVal : NativeUint):NativeUint;
//  maxVal = 10000;maxCoor = 77-2;// maxCoor*maxCoor    *1,778;     0.009sec
//  maxVal = 100000;maxCoor = 236-2;// maxCoor*maxCoor  *1.826;     0.825sec
//  maxVal = 1000000;maxCoor = 732-2;// maxCoor*maxCoor *1.877;    74    sec
Begin
  result := trunc(sqrt(maxval/1.75))+3;
end;

procedure clear;
begin
  setlength(Grid,0);
  setlength(Rowlimits,0);
  s := '';
end;

procedure InitGrid(var G:tGrid;InitVal:NativeUint);
var
  row,middle: nativeINt;
begin
//  setlength(Rowlimits,0);   setlength(G,0);
  MaxCoor :=  CalcMaxCoor(InitVal);
  setlength(G,sqr(maxCoor));
  setlength(Rowlimits,maxCoor);
  fillchar(G[0],length(G)*SizeOf(G[0]),#0);

  middle := (maxCoor) div 2;
  Grid[middle*maxcoor+middle] := InitVal;
  For row := 1 to maxCoor do
    with Rowlimits[row] do
    Begin
      lmtLow := middle;
      lmtHigh := middle;
    end;

  with Rowlimits[middle] do
  Begin
    lmtLow := middle;
    lmtHigh := middle;
  end;
end;
procedure OutGridPPM(const G:tGrid;maxValue : NativeUint);
const
  color : array[0..3] of array[0..2] of Byte =
             //R,G,B)
            ((0,0,0),
             (255,0,0),
             (0,255,0),
             (0,0,255));
var
  f :text;
  pActRow: tOneRow;
  col,row,sIdx,value : NativeInt;
Begin
  Assignfile(f,'ppm/Grid_'+IntToStr(maxValue)+'.ppm');
  rewrite(f);
  write(f,Format('P6 %d %d %d ',[maxCoor-1,maxCoor-1,255]));
  setlength(s,(maxCoor-1)*3);
  pActRow :=@G[0];
  For row := maxCoor-2 downto 0 do
  Begin
    inc(pActRow,maxCoor);
    sIdx := 1;
    For col := 1 to maxCoor-1 do
    Begin
      value := pActRow[col];
      s[sIdx]   := CHR(color[value,0]);
      s[sIdx+1] := CHR(color[value,1]);
      s[sIdx+2] := CHR(color[value,2]);
      inc(sIdx,3);
    end;
    write(f,s);
  end;
  CloseFile(f);
end;

procedure OutGrid(const G:tGrid);
//output of grid and test, if no sand is lost
var
  pActRow: tOneRow;
  col,row,sum,value : NativeUint;
Begin
  setlength(s,maxcoor-1);
  pActRow := @G[0];
  sum := 0;
  For row := maxCoor-1 downto 1 do
  Begin
    inc(pActRow,maxcoor);
    For col := 1 to maxCoor-1 do
    Begin
      value := pActRow[col];
//      IF value>=4 then writeln(row:5,col:5,value:13);
      s[col] := chr(value+48);
      inc(sum,value);
    end;
    if maxCoor <80 then
      writeln(s);
  end;
  writeln('columns ',maxcoor-1,' checksum ',maxVal,' ?=? ',sum);
{
  For row := 1 to maxCoor do
    with Rowlimits[row] do
      writeln(lmtLow:10,lmtHigh:10);
      * }
end;

procedure Evolution(var G:tGrid);
var
  pActRow,pRowBefore,pRowAfter : tOneRow;
  col,row,mul,val,done : NativeUint;
begin
  repeat
    pRowBefore := @G[0];
    pActRow    := @G[maxcoor];
    pRowAfter  := @G[2*maxcoor];
    done := 0;
    For row := maxCoor-1 downto 1 do
    Begin
      with RowLimits[row] do
      Begin
      while (LmtLow >1) AND (pActRow[lmtLow]<> 0) do
        dec(lmtLow);
      while (lmtHigh < maxCoor) AND (pActRow[lmtHigh]<> 0) do
        inc(lmtHigh);
      For col := lmtLow to lmtHigh do
      Begin
        val := pActRow[col];
        IF val >=4 then
        Begin
          mul := val DIV 4;
          done := val;
          inc(pRowBefore[col],mul);
          inc(pActRow[col-1],mul);
          pActRow[col] := val-4*Mul;
          inc(pActRow[col+1],mul);
          inc(pRowAfter[col],mul);
        end;
      end;
      pRowBefore:= pActRow;
      pActRow := pRowAfter;
      inc(pRowAfter,maxcoor);
    end;
    end;
  until done=0;
end;

procedure OneTurn(count:NativeUint);
begin
  Writeln(' Test abelian sandpile( ',count,' )');
  MaxVal := count;
  InitGrid(Grid,count);
  Evolution(Grid);
  OutGrid(Grid);
  OutGridPPM(Grid,count);
  clear;
end;

BEGIN
  OneTurn(4);
  OneTurn(16);
  OneTurn(64);
  OneTurn(1000);
  OneTurn(10000);
  OneTurn(100000);
END.

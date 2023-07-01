program NQueens;
{$IFDEF FPC}
   {$MODE DELPHI}
   {$OPTIMIZATION ON}{$OPTIMIZATION REGVAR}{$OPTIMIZATION PeepHole}
   {$OPTIMIZATION CSE}{$OPTIMIZATION ASMCSE}
{$ELSE}
  {$Apptype console}
{$ENDIF}

uses
  sysutils;// TDatetime
const
  nmax = 17;
type
{$IFNDEF FPC}
  NativeInt = longInt;
{$ENDIF}
  //ala Nikolaus Wirth  A-1  = H - 8
  //diagonal left  (A1) to rigth (H8)
  tLR_diagonale = array[-nmax-1..nmax-1] of char;
  //diagonal right (A8) to left (H1)
  tRL_diagonale = array[0..2*nmax-2] of char;
  //up to Col are the used Cols, after that the unused
  tFreeCol = array[0..nmax-1] of nativeInt;
var
  LR_diagonale:tLR_diagonale;
  RL_diagonale:tRL_diagonale;
  //Using pChar, cause it is implicit an array
  //It is always set to
  //@LR_diagonale[row] ,@RL_diagonale[row]
  pLR,pRL : pChar;
  FreeCol : tFreeCol;
  i,
  n : nativeInt;
  gblCount : nativeUInt;
  T0,T1 : TdateTime;
procedure Solution;
var
  i : NativeInt;
begin
// Take's a lot of time under DOS/Win32
  If gblCount AND $FFF = 0 then
    write(gblCount:10,#8#8#8#8#8#8#8#8#8#8);
  // IF n< 9 then
  IF n < 0 then
   begin
     For i := 1 to n do
       write(FreeCol[i]:4);
     writeln;
   end;
end;

procedure SetQueen(Row:nativeInt);
var
  i,Col : nativeInt;
begin
IF row <= n then
  begin
  For i := row to n do
    begin
    Col := FreeCol[i];
    //check diagonals occupied
    If (ORD(pLR[-Col]) AND ORD(pRL[Col]))<>0 then
      begin
      //a "free" position is found
      //mark it
      pRL[ Col]:=#0;      //RL_Diagonale[ Row +Col] := 0;
      pLR[-Col]:=#0;      //LR_Diagonale[ Row -Col] := 0;
      //swap FreeRow[Row<->i]
      FreeCol[i] := FreeCol[Row];
      //next row
      inc(pRL);
      inc(pLR);
      FreeCol[Row] := Col;
      // check next row
        SetQueen(Row+1);
      //Undo
      dec(pLR);
      dec(pRL);
      FreeCol[Row] := FreeCol[i];
      FreeCol[i] := Col;
      pRL[ Col]:=#1;
      pLR[-Col]:=#1;
      end;
    end;
  end
else
  begin
  //solution ist found
  inc(gblCount);
  //Solution
  end;
end;

begin
  For i := 0 to nmax-1 do
    FreeCol[i] := i;
  //diagonals filled with True = #1 , something <>0
  fillchar(LR_Diagonale[low(LR_Diagonale)],sizeof(tLR_Diagonale),#1);
  fillchar(RL_Diagonale[low(RL_Diagonale)],sizeof(tRL_Diagonale),#1);
  For n := 1 to nMax do
    begin
    t0 := time;
    pLR:=@LR_Diagonale[0];
    pRL:=@RL_Diagonale[0];
    gblCount := 0;
    SetQueen(1);
    t1:= time;
    WriteLn(n:6,gblCount:12,FormatDateTime(' NN:SS.ZZZ',T1-t0),' secs');
    end;
  WriteLn('Fertig');
end.

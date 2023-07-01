PROGRAM magic;
{$IFDEF FPC }{$MODE DELPHI}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
(* Magic squares of odd order *)
type
  tsquare = array of array of LongInt;
  trowcol = array of NativeInt;

function GenShuffleRowCol(n: nativeInt):trowcol;
var
  i,j,tmp: NativeInt;
begin
  setlength(result,0);
  IF n > 0 then
  Begin
    setlength(result,n);
    For i := 0 to n-1 do
      result[i] := i;
    //shuffle
    For i := n-1 downto 1 do
    Begin
      j := random(i+1);//j == [0..i]
      tmp := result[i];result[i]:= result[j];result[j]:= tmp;
    end;
  end;
end;

function MagicSqrOdd(n:nativeInt;SwapColRoW:boolean):tsquare;
VAR
  rowIdx,colIdx,row,col,num :NativeInt;
  cols,rows :trowcol;
BEGIN
  rows:= GenShuffleRowCol(n);
  cols:= GenShuffleRowCol(n);
  setlength(result,n,n);
  FOR rowIdx:= 0 TO n-1 DO
  BEGIN
    row := rows[rowIdx];
    FOR colIdx:=0 TO n-1 DO
    Begin
      col := cols[colIdx];
      //corrected formula cause row :0..n*1-> corrected to 1..n
      num := (row*2-col+n+2) MOD n*n + (row*2+col+1) MOD n+1;
      IF SwapColRoW then
        result[colIdx,rowIdx] := num
      else
        result[rowIdx,colIdx] := num;
    end;
  END;
END;

function MagicSqrCheck(const Mq:tsquare):boolean;
var
  row,col,rowsum,mn,n,itm: NativeInt;
  colSum:trowcol;
begin
  n := length(Mq[0]);
  mn := n*(n*n+1) DIV 2;
  setlength(colsum,n);//automatic initialised to zero
  For row := n-1 downto 0 do
  Begin
    //check one row
    rowsum := 0;
    For col := n-1 downto 0 do
    Begin
      itm := Mq[row,col];
      write(itm:4);
      inc(rowsum,itm);
      //sum up the columns too, for I'm just here
      inc(colSum[col],itm);
    end;
    writeln;
    result := (rowsum=mn);
    IF Not(result) then begin writeln(row:4,col:4,rowsum:10);EXIT;end;
  end;
  //check columns
  For col := n-1 downto 0 do
  Begin
    result := (colSum[col]=mn);
    IF Not(result) then begin writeln(col:4,colSum[col]:10);EXIT;end;
  end;
  writeln;
end;


var
  n,mn : nativeInt;
  Mq : tsquare;
Begin
  randomize;
  n := 9;
  mn := n*(n*n+1) DIV 2;
  WRITELN('The square order is: ',n);
  WRITELN('The magic number is: ',mn);
  Mq := MagicSqrOdd(n,random(2)=0);
  writeln(MagicSqrCheck(Mq));
end.

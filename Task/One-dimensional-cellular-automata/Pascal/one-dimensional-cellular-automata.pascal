program Test;
{$IFDEF FPC}{$MODE DELPHI}{$ELSE}{$APPTYPE}{$ENDIF}
uses
  sysutils;
const
  cCHAR: array[0..1] of char = ('_','#');
type
  TRow =  array of byte;

function ConvertToRow(const s:string):tRow;
var
  i : NativeInt;
Begin
  i := length(s);
  setlength(Result,length(s));
  For i := i downto 0 do
    result[i-1]:= ORD(s[i]=cChar[1]);
end;

function OutRow(const row:tRow):string;
//create output string
var
  i: NativeInt;
Begin
  i := length(row);
  setlength(result,i);
  For i := i downto 1 do
    result[i]:= cChar[row[i-1]];
end;

procedure NextRow(row:pByteArray;MaxIdx:NativeInt);
//compute next row in place by the using a small storage for the
//2 values, that would otherwise be overridden
var
  leftValue,Value: NativeInt;
  i,trpCnt: NativeInt;
Begin
  leftValue := 0;
  trpCnt := row[0]+row[1];

  i := 0;
  while i < MaxIdx do
  Begin
    Value := row[i];
    //the rule for survive : PopCnt == 2
    row[i] := ORD(trpCnt= 2);
    //reduce popcnt of element before
    dec(trpCnt,leftValue);
    //goto next element
    inc(i);
    leftValue := Value;
    //increment popcnt by right element
    inc(trpCnt,row[i+1]);
    //move to next position in ring buffer
  end;
  row[MaxIdx] := ORD(trpCnt= 2);
end;

const
  TestString: string='  ### ## # # # #  #  ';
var
  s: string;
  row:tRow;
  i: NativeInt;
begin
  s := Teststring;
  row:= ConvertToRow(s);
  For i := 0 to 9 do
  Begin
    writeln(OutRow(row));
    NextRow(@row[0],High(row));
  end;
end.

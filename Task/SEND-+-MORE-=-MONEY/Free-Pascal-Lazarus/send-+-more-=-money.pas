program SymbolToDigit;
{$IFDEF FPC}{$MODE DELPHI}{$Optimization ON,All}{$ENDIF}
{$IFDEF Windows}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;// TDatetime
const
  nmax = 9;
  maxLen = 7;

type
 tFreeDgt = array[0..nmax+1] of Int32;
 tSymbWord = String[maxLen];

 tDgtWord =  record
               DW_DgtsIdx: array[1..maxLen] of UInt8;
               DW_maxIdx: Uint8;
             end;

 tDgtFront  =  record
                 DW_DgtsIdx: array[1..nmax+1] of UInt8;
                 DW_maxIdx: Uint8;
               end;
  tInUse = set of 0..nmax+1;
const
{
  maxIDx = 2;
  cSumWords : array[0..maxIDx] of tSymbWord =('SEND','MORE','MONEY');
}
{
  maxIDx = 4;
  cSumWords : array[0..maxIDx]  of tSymbWord =('ABRA','CADABRA','ABRA','CADABRA','HOUDINI');
}

//MANYOTHERS=M2A7N6Y4O1T9H5E0R8S3
  maxIDx = 41;
  cSumWords : array[0..maxIDx] of tSymbWord =(
    'SO','MANY','MORE','MEN','SEEM','TO','SAY','THAT',
    'THEY','MAY','SOON','TRY','TO','STAY','AT','HOME',
    'SO','AS','TO','SEE','OR','HEAR','THE','SAME','ONE',
    'MAN','TRY','TO','MEET','THE','TEAM','ON','THE',
    'MOON','AS','HE','HAS','AT','THE','OTHER','TEN',
    'TESTS');

var
{$ALIGN 32}
  DigitSample,
  DigitSampleSolution : tFreeDgt;
  SymbInUse : array[0..10] of char;
  Words :array[0..maxIDx] of tSymbWord;
  DgtWords : array[0..maxIDx] of tDgtWord;
  DgtFrontWords :tDgtFront;
  SymbInUseCount,gblCount : Uint32;
  fullStop: boolean;
  ch : char;

procedure OneSol(idx:int32;const DS:tFreeDgt);
var
  i,symbolIdx : Int32;
begin
  For i := maxlen downto 1 do
  begin
    symbolIdx :=  DgtWords[idx].DW_DgtsIdx[i];
    if symbolIdx = 0 then
      write(' ')
    else
      write(DS[symbolIdx]);
  end;
  writeln(cSumWords[idx]:maxLen+2);
end;

procedure RevString(var s:tSymbWord);
var
  i,j: NativeInt;
begin
  i := 1;
  j := Length(s);
  while j>i do
  begin
    ch:= s[i];s[i]:= s[j];s[j] := ch;
    inc(i);dec(j);
  end;
end;

procedure GetSymbols;
var
  //CHR(ORD('A')-1) = '@' is placeholder for no Symbol
  SymbToIdx : array['@'..'Z'] of byte;
  FrontSymbols :tInUse;
  i,j : Int32;
Begin
  fillchar(SymbToIdx,SizeOf(SymbToIdx),#255);
  SymbToIdx['@'] := 0;
  SymbInUseCount := 1;//['@'] is always zero

  For i := 0 to maxIDx do
  begin
    Words[i] := cSumWords[i];
    j := length(Words[i]);
    //position of highest symbol
    DgtWords[i].DW_maxIdx := j;
    // extend by '@' aka zero
    RevString(Words[i]);
    setlength(Words[i],maxlen);
    For j := j+1 to maxLen do
      Words[i][j] := Low(SymbToIdx);
  end;
  // find all symbols
  for j := 1 to High(tSymbWord) do
  Begin
    For i := 0 to maxIdx do
    begin
      ch := Words[i][j];
      if SymbToIdx[ch] = 255 then
      begin
        SymbToIdx[ch] := SymbInUseCount;
        SymbInUse[SymbInUseCount] := ch;
        inc(SymbInUseCount);
      end;
    end;
  end;
  dec(SymbInUseCount);
  For i := 1 to SymbInUseCount do
    write(SymbInUse[i]);
  writeln(SymbInUseCount:4,' symbols');

  //get index for every symbol in word
  For i := 0 to maxIdx do
    with DgtWords[i] do
      for j := 1 to High(tSymbWord) do
        DW_DgtsIdx[j]:= SymbToIdx[Words[i][j]];

  //find all first symbols
  FrontSymbols := [];
  For i := 0 to maxIDx do
    with DgtWords[i] do
      include(FrontSymbols,DW_DgtsIdx[DW_maxIdx]);

  j := 1;
  For i := 0 to nmax+1 do
    if i in FrontSymbols then
    Begin
      DgtFrontWords.DW_DgtsIdx[j] := i;
      inc(j);
    end;
  DgtFrontWords.DW_maxIdx := j-1;
end;

function AddWords(const DS:tFreeDgt):boolean;
var
  col,row,
  sum,carry : NativeUInt;
begin
  // check for zero in first symbols of words
  with DgtFrontWords do
    For col := DW_maxIdx downto 1 do
    begin
      if DS[DW_DgtsIdx[col]] = 0 then
        EXIT(false);
    end;

  carry := 0;
  For col := 1 to maxLen do
  Begin
    sum := carry;
    carry := 0;
    // add one column
    For row := maxIdx-1 downto 0 do
      sum := sum+DS[DgtWords[row].DW_DgtsIdx[col]];

    if sum > 9 then
    begin
      carry := sum DIV 10;
      sum := sum - 10 * carry;
    end;
    //digit of sum
    if sum <> DS[DgtWords[maxIDx].DW_DgtsIdx[col]] then
      EXIT(false);
  end;
  If Carry = 0 then
    DigitSampleSolution := DS;
  EXIT(true);
end;

procedure NextPermute(Row:nativeInt;var DS:tFreeDgt);
var
  i,Col : nativeInt;
begin
  if fullStop then   EXIT;
  IF row <= 10 then
  begin
    NextPermute(Row+1,DS);
    For i := row+1 to 10 do
    begin
      //swap
      Col := DS[i];
      DS[i] := DS[Row];
      DS[Row] := Col;
        NextPermute(Row+1,DS);
      //Undo swap
      DS[Row] := DS[i];
      DS[i] := Col;
    end
  end
else
  begin
    fullStop :=  AddWords(DS);
    inc(gblCount);
  end
end;

var
  T1,T0: TDateTime;
  i,j : Uint32;

begin
  DigitSample[0] := 0;
  For i := 0 to nmax do
    DigitSample[i+1] := i;
  GetSymbols;

  t0 := time;
  gblCount := 0;
  fullStop := false;
  NextPermute(1,DigitSample);
  t1:= time;
  IF maxIDx < 10 then
    For i := 0 to High(DgtWords)do
      OneSol(i,DigitSampleSolution);
  writeln;
  For i := 1 to SymbInUseCount do
  begin
     j := DigitSampleSolution[i];
     write(SymbInUse[i],'=',j,' ');
  end;
  writeln;
  WriteLn(gblCount,' checks ',FormatDateTime(' NN:SS.ZZZ',T1-t0),' secs');
end.

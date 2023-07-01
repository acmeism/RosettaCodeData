const
  base    = 10;
  MaxDigitCnt = 11;
  source1 : array[0..7] of integer = (1, 34, 3, 98, 9, 76, 45, 4);
  source2 : array[0..3] of integer = (54,546,548,60);
  source3 : array[0..3] of integer = (60, 54,545454546,0);

type
  tdata = record
            datOrg,
            datMod : LongWord;
            datStrOrg       : string[MaxDigitCnt];
          end;
  tArrData = array of tData;

procedure DigitCount(var n: tdata);
begin
  with n do
    //InttoStr is very fast
    str(datOrg,datStrOrg);

end;

procedure InsertData(var n: tdata;data:LongWord);
begin
  n.datOrg := data;
  DigitCount(n);
end;

function FindMaxLen(const ArrData:tArrData): LongWord;
var
  cnt : longInt;
  res,t : LongWord;
begin
  res := 0;// 1 is minimum
  for cnt :=  High(ArrData) downto Low(ArrData) do
  begin
    t := length(ArrData[cnt].datStrOrg);
    IF res < t then
      res := t;
  end;
  FindMaxLen := res;
end;

procedure ExtendCount(var ArrData:tArrData;newLen: integer);
var
  cnt,
  i,k : integer;
begin
  For cnt := High(ArrData) downto Low(ArrData) do
    with ArrData[cnt] do
    begin
      datMod := datOrg;
      i := newlen-length(datStrOrg);
      k := 1;
      while i > 0 do
      begin
        datMod := datMod *Base+Ord(datStrOrg[k])-Ord('0');
        inc(k);
        IF k >length(datStrOrg) then
          k := 1;
        dec(i);
      end;
    end;
end;

procedure SortArrData(var ArrData:tArrData);
var
  i,
  j,idx : integer;
  tmpData : tData;
begin
  For i := High(ArrData) downto Low(ArrData)+1 do
  begin
    idx := i;
    j := i-1;
    For j := j downto Low(ArrData) do
      IF ArrData[idx].datMod < ArrData[j].datMod then
         idx := j;
    IF idx <> i then
    begin
      tmpData     := ArrData[idx];
      ArrData[idx]:= ArrData[i];
      ArrData[i]  := tmpData;
    end;
  end;
end;

procedure ArrDataOutput(const ArrData:tArrData);
var
  i,l : integer;
  s : AnsiString;
begin
{ the easy way
  For i := High(ArrData) downto Low(ArrData) do
    write(ArrData[i].datStrOrg);
  writeln;
  *}
  l := 0;
  For i := High(ArrData) downto Low(ArrData) do
    inc(l,length(ArrData[i].datStrOrg));
  setlength(s,l);
  l:= 1;
  For i := High(ArrData) downto Low(ArrData) do
    with ArrData[i] do
    begin
      move(datStrOrg[1],s[l],length(datStrOrg));
      inc(l,length(datStrOrg));
    end;
  writeln(s);
end;

procedure HighestInt(var  ArrData:tArrData);
begin
  ExtendCount(ArrData,FindMaxLen(ArrData));
  SortArrData(ArrData);
  ArrDataOutput(ArrData);
end;

var
  i : integer;
  tmpData : tArrData;
begin
  // Source1
  setlength(tmpData,length(source1));
  For i := low(tmpData) to high(tmpData) do
    InsertData(tmpData[i],source1[i]);
  HighestInt(tmpData);
  // Source2
  setlength(tmpData,length(source2));
  For i := low(tmpData) to high(tmpData) do
    InsertData(tmpData[i],source2[i]);
  HighestInt(tmpData);
  // Source3
  setlength(tmpData,length(source3));
  For i := low(tmpData) to high(tmpData) do
    InsertData(tmpData[i],source3[i]);
  HighestInt(tmpData);
end.

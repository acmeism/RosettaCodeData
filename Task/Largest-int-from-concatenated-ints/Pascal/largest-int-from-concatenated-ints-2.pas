const
  base    = 10;
  MaxDigitCnt = 11;
  source1 : array[0..7] of LongInt = (10 , 34, 3, 98, 9, 76, 45, 4);
  source2 : array[0..3] of LongInt = (54,546,548,60);
  source3 : array[0..3] of LongInt = (0,2121212122,21,60);

type
  tdata = record
            datMod : double;
            datOrg : LongInt;
//InttoStr is very fast and the string is always needed
            datStrOrg       : string[MaxDigitCnt];
          end;
  tArrData = array of tData;

procedure InsertData(var n: tdata;data:LongWord);
begin
  with n do
  begin
    datOrg := data;
    str(datOrg,datStrOrg);
  end;
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

procedure ExtendData(var ArrData:tArrData;newLen: integer);
var
  cnt,
  i : integer;
begin
  For cnt := High(ArrData) downto Low(ArrData) do
    with ArrData[cnt] do
    begin
      //generating 10^length(datStrOrg)
      datMod := 1;
      i := length(datStrOrg);
      // i always >= 1
      repeat
        datMod := base*datMod;
        dec(i);
      until i <= 0;
//      1/(datMod-1.0) = 1/(9...9)
      datMod := datOrg/(datMod-1.0)+datOrg;
      i := newlen-length(datStrOrg);
      For i := i downto 1 do
        datMod := datMod*Base;
    end;
end;

procedure SortArrData(var ArrData:tArrData);
//selection sort
var
  i,
  j,idx : integer;
  tmpData : tData;
begin
  For i := High(ArrData) downto Low(ArrData)+1 do
  begin
    idx := i;
    j := i-1;
    //select max
    For j := j downto Low(ArrData) do
      IF ArrData[idx].datMod < ArrData[j].datMod then
         idx := j;
    //finally swap
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
  i : integer;
begin
{ the easy way}
  For i := High(ArrData) downto Low(ArrData) do
    write(ArrData[i].datStrOrg);
  writeln;
end;

procedure HighestInt(var  ArrData:tArrData);
begin
  ExtendData(ArrData,FindMaxLen(ArrData));
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

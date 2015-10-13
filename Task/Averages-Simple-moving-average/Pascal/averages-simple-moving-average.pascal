program sma;
type
  tsma = record
            smaValue : array of double;
            smaAverage,
            smaSumOld,
            smaSumNew,
            smaRezActLength : double;
            smaActLength,
            smaLength,
            smaPos   :NativeInt;
            smaIsntFull: boolean;
         end;

procedure smaInit(var sma:tsma;p: NativeUint);
Begin
  with sma do
  Begin
    setlength(smaValue,0);
    setlength(smaValue,p);
    smaLength:= p;
    smaActLength := 0;
    smaAverage:= 0.0;
    smaSumOld := 0.0;
    smaSumNew := 0.0;
    smaPos := p-1;
    smaIsntFull := true
    end;
end;

function smaAddValue(var sma:tsma;v: double):double;
Begin
  with sma do
  Begin
    IF smaIsntFull then
    Begin
      inc(smaActLength);
      smaRezActLength := 1/smaActLength;
      smaIsntFull :=  smaActLength < smaLength ;
    end;
    smaSumOld := smaSumOld+v-smaValue[smaPos];
    smaValue[smaPos] := v;
    smaSumNew := smaSumNew+v;

    smaPos := smaPos-1;
    if smaPos < 0 then
    begin
      smaSumOld:= smaSumNew;
      smaSumNew:= 0.0;
      smaPos := smaLength-1;
    end;
    smaAverage := smaSumOld *smaRezActLength;
    smaAddValue:= smaAverage;
  end;
end;

var
 sma3,sma5:tsma;
 i : LongInt;
begin
  smaInit(sma3,3);
  smaInit(sma5,5);
  For i := 1 to 5 do
  Begin
    write('Inserting ',i,' into sma3 ',smaAddValue(sma3,i):0:4);
    writeln(' Inserting ',i,' into sma5 ',smaAddValue(sma5,i):0:4);
  end;
  For i := 5 downto 1 do
  Begin
    write('Inserting ',i,' into sma3 ',smaAddValue(sma3,i):0:4);
    writeln(' Inserting ',i,' into sma5 ',smaAddValue(sma5,i):0:4);
  end;
  //speed test
  smaInit(sma3,3);
  For i := 1 to 100000000 do
    smaAddValue(sma3,i);
  writeln('100''000''000 insertions ',sma3.smaAverage:0:4);
end.

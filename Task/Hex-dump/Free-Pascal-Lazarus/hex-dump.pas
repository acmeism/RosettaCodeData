program HEXDUMP;
{$MODE DELPHI}{$OPTIMIZATION ON,ALL}

type
  tByteToHexTbl = array[0..256*2-1] of AnsiChar;
  tByteToBinTbl = Array[0..256-1] of Uint64;
  tOutChar = array[0..255] of AnsiChar;
const
    TestUTF8STring = 'Rosettacode is a programming crestomathy site 😀.    🍨 👨‍👩‍👦 ⚽ ¯\_(ツ)_/¯';
//  Hex_NUl_Format = ' 00000000 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|';
    Hex_NUl_Format = '                                                            |                |';
    cHexOfsText = 61; //                                                           ^
    cOneRowHexBlock = 16;

//  Bin_NUl_Format = ' 00000000  00000000 00000000 00000000 00000000 00000000 00000000   |      |';
    Bin_NUl_Format = '                                                                   |      |';
    cBinOfsText = 68; //                                                                  ^
    cOneRowBinBlock = 6;

    LCM_BinHex = cOneRowBinBlock*cOneRowHexBlock DIV 2;
    cWantedSize = 256;
    cBufBlockSize = cWantedSize;//((cWantedSize -1) DIV LCM_BinHex)*LCM_BinHex;

var
  FileBuf: array[0..cBufBlockSize-1] of byte;
  ByteToBinTbl :tByteToBinTbl;
  ByteToHexTbl : tByteToHexTbl;

  OutChar :tOutChar;
  OutHexString : AnsiString;
  OutBinString : AnsiString;
  StartHex,EndHex:AnsiString;
  FileToView: file;

  procedure InitOutChar(var tbl:tOutChar);
  var
    i: Int32;
  begin
    fillchar(tbl,SizeOf(tbl),'.');
    For i := 32 to 127 do
      tbl[i] := AnsiChar(i);
  end;

  procedure InitByteToBin(var tbl:tByteToBinTbl);
  var
//  Test: String[8];
    Lmt,Mask,idx,idx1 : Uint64;
  begin
    Mask := Ord('0');
    idx := 8;
    repeat
      Mask := Mask shl idx + Mask;
      idx +=idx;
    until idx >= 64;
    TBL[0] := Mask;
//  TBL[0] = '00000000'
    Lmt := 1;
    //little endian
    Mask := 1 shl 56;
    //big endian  Mask := 1;
    repeat
      idx := 0;
      idx1 := Lmt;
      repeat
        Tbl[idx1] := tbl[idx] OR Mask;// set Bit "0" ->"1"
        inc(idx);
        inc(idx1);
      until idx = Lmt;
      //little endian
      Mask := Mask shr 8;
      //big endian  Mask := Mask shl 8;
      Lmt += Lmt;
   until Lmt >= 256;
  end;

  procedure InitByteToHexTbl(var tbl:tByteToHexTbl);
  const
    ConvTbl : array[0..15] of AnsiChar =
      ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
  var
    ch : AnsiChar;
    i,j,idx : Int32;
  begin
    idx := 0;
    For i := 0 to 15 do
    Begin
      ch := ConvTbl[i];
      For j := 0 to 15 do
      begin
        tbl[idx] := ch;
        tbl[idx+1] := ConvTbl[j];
        inc(idx,2);
      end;
    end;
  end;

  procedure Init;
  Begin
    InitByteToHexTbl(ByteToHexTbl);
    InitByteToBin(ByteToBinTbl);
    InitOutChar(OutChar);

    OutHexString := Hex_NUl_Format;
    uniquestring(OutHexString);

    OutBinString := Bin_NUl_Format;
    uniquestring(OutBinString);

    setlength(StartHex,8);
    uniquestring(StartHex);
    setlength(EndHex,8);
    uniquestring(EndHex);
  end;

  function InitFIle(var FileName:String):Boolean;
  var
    i : integer;
  Begin
    if FileName = '' then
    begin
      For i:=1 to ParamCount do
        FileName := ParamStr(1);
      if FileName = '' then
        EXIT(false);
    end;
    {$I-}
    Assign(FileToView, FileName);
    Reset(FileToView, 1);
    {$I+}
    if IoResult <> 0 then
       EXIT(false);
    Exit(true);
  end;

  procedure ByteHex2Str(value:NativeInt;p: pAnsiChar);inline;
  begin
    value := value AND $FF;
    value += value;
    p[0] := ByteToHexTbl[value];
    inc(value);
    p[1] := ByteToHexTbl[value];
  end;

  procedure LongHex2Str(Value: Int32;p: pAnsiChar);
  var
    val: byte;
  begin
    val := (Value AND $FF000000) shr 24;
    ByteHex2Str(Val,p);
    val := (Value AND $00FF0000) shr 16;
    ByteHex2Str(Val,@p[2]);
    val := (Value AND $0000FF00) shr  8;
    ByteHex2Str(Val,@p[4]);
    val := (Value AND $00000FF);
    ByteHex2Str(Val,@p[6]);
  end;

  procedure  OutOneHexRow(pB : pByte;currpos,readed: NativeInt);
  var
    pOutString : pAnsiChar;
    i,idx : Int32;
  Begin
    if readed<= 0 then
      EXIT;
//  OutHexString := Hex_NUl_Format;  uniquestring(OutHexString);
    move(Hex_NUl_Format[1],OutHexString[1],Length(Hex_NUl_Format));
    pOutString := @OutHexString[1];

    idx := 1;
    LongHex2Str(CurrPos,@pOutString[idx]);
    idx += 9;

    for I := 0 to cOneRowHexBlock-1 do
    begin
      if I < readed then
      begin
        ByteHex2Str(pB[I],@pOutString[idx]);
        idx+= 3;
      end
      else
        BREAK;
      if I = 7 then
        inc(idx);
    end;

    idx := cHexOfsText;
    for I := 0 to cOneRowHexBlock-1 do
    begin
      if I < readed then
        pOutString[idx+i] := OutChar[pB[i]]
      else
        BREAK;
     end;
   end;

  procedure OutHex(const pB : pByte;Ofs,StartIdx,ByteReaded: NativeINt);
  begin
    LongHex2Str(Ofs,pAnsiChar(StartHex));
    LongHex2Str(Ofs+ByteReaded,pAnsiChar(EndHex));
    writeln('From ',StartHex,' to ',EndHex);

    while byteReaded - StartIdx >= cOneRowHexBlock do
    begin
      OutOneHexRow(@pB[StartIdx],Ofs,cOneRowHexBlock);
      writeln(OutHexString);
      Inc(Ofs,cOneRowHexBlock);
      inc(StartIdx,cOneRowHexBlock);
    end;
    IF ByteReaded-StartIdx > 0 then
    begin
      OutOneHexRow(@pB[StartIdx],Ofs,ByteReaded-StartIdx);
      writeln(OutHexString);
    end;
  end;

 procedure  OutOneBinRow(pB : pByte;currpos,readed: NativeInt);
  var
    pOutString : pAnsiChar;
    i,idx : Int32;
  Begin
    if readed<= 0 then
      EXIT;
    move(Bin_NUl_Format[1],OutBinString[1],Length(Bin_NUl_Format));
    pOutString := @OutBinString[1];

    idx := 1;
    LongHex2Str(CurrPos,@pOutString[idx]);
    idx += 10;

    for I := 0 to cOneRowBinBlock-1 do
    begin
      if I < readed then
      begin
//      move(ByteToBinTbl[pB[I]],pOutString[idx],8);
        pUint64(@pOutString[idx])^ := ByteToBinTbl[pB[I]];
        idx+= 9;
      end
    end;

    idx := cBinOfsText;
    for I := 0 to cOneRowBinBlock-1 do
    begin
      if I < readed then
        pOutString[idx+i] := OutChar[pB[i]]
      else
        BREAK;
    end;
  end;

  procedure OutBin(const pB : pByte;Ofs,StartIdx,ByteReaded: NativeInt);
  begin
    LongHex2Str(Ofs,pAnsiChar(StartHex));
    LongHex2Str(Ofs+ByteReaded,pAnsiChar(EndHex));
    writeln('From ',StartHex,' to ',EndHex);

    while byteReaded - StartIdx >= cOneRowBinBlock do
    begin
      OutOneBinRow(@pB[StartIdx],Ofs,cOneRowBinBlock);
      writeln(OutBinString);
      Inc(Ofs,cOneRowBinBlock);
      inc(StartIdx,cOneRowBinBlock);
    end;
    IF ByteReaded-StartIdx > 0 then
    begin
      OutOneBinRow(@pB[StartIdx],Ofs,ByteReaded-StartIdx);
      writeln(OutBinString);
    end;
  end;

var
  TestString : UTF8String;
  FileName: string;
  currPos,ByteReaded,StartOfs: NativeInt;
begin
  Init;
// 'Rosettacode is a programming crestomathy site 😀.    🍨 👨‍👩‍👦 ⚽ ¯\_(ツ)_/¯';
  TestSTring := TestUTF8STring;
  uniquestring(TestString);
  ByteReaded := Length(TestString)+4;

  OutHex(@TestSTring[1],0,0,ByteReaded);
  writeln;
  OutHex(@TestSTring[1],17,17,28);
  writeln;
  OutBin(@TestSTring[1],0,0,ByteReaded);
  writeln;
  OutBin(@TestSTring[1],17,17,28);
  writeln;

  StartOfs:= 0;
  FileName := '';
  If InitFile(FileName) then
  Begin
    CurrPos :=StartOfs;
    while not EOF(FileToView) do
    begin
      BlockRead(FileToView, FileBuf, cBufBlockSize, ByteReaded);
      OutBin(@FileBuf,CurrPos,0,ByteReaded);
      Inc(CurrPos,cBufBlockSize);
    end;
    LongHex2Str(StartOfs,pAnsiChar(StartHex));
    LongHex2Str(FileSize(FileToView),pAnsiChar(EndHex));
    writeln('From ',StartHex,' to ',EndHex,' total');
    writeln;

    reset(FileToView,1);
    CurrPos :=StartOfs;
    while not EOF(FileToView) do
    begin
      BlockRead(FileToView, FileBuf, cBufBlockSize, ByteReaded);
      OutHex(@FileBuf,CurrPos,0,ByteReaded);
      Inc(CurrPos,cBufBlockSize);
    end;
    LongHex2Str(StartOfs,pAnsiChar(StartHex));
    LongHex2Str(FileSize(FileToView),pAnsiChar(EndHex));
    writeln('From ',StartHex,' to ',EndHex,' total');
    Close(FileToView);
  end;
end.

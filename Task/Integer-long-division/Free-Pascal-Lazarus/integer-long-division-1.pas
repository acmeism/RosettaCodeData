PROGRAM Periode;
{$IFDEF FPC}  {$MODE Delphi} {$OPTIMIZATION ON,ALL} {$ENDIF}
{$IFDEF WINDOWS}{$Apptype Console}{$ENDIF}
uses
  sysutils;

const
  cTestVal : array[0..11] of LongInt = (2,5,3,7,13,17,60,149,555,625,5261,high(longInt));
  // don't try cBase= 7 for high(longInt) length of period=2147483647 -1
  cBase = 10;
  cLen = 80;// 1 shl 14 is much faster for high(longInt) 2.9 s -> 2.0 s

var
  pS : pAnsiChar;
  s : array of AnsiString;
  idxS,
  idxP : integer;

  function CheckMaxStartOfPeriod(dom:LongInt):longInt;
  var
    n : Int64;
    quot : longInt;
  Begin
    n := 1;
    result := 1;
    repeat
      n *=cbase;
      quot := n DIV dom;
      n -= dom*quot;
      if (n = 0) OR (quot<>0) then
        BREAK;
      inc(result);
    until false;
  end;

  procedure Xtend;
  begin
    idxS += 1;
    setlength(s,idxS+1);
    setlength(s[idxS],cLen);
    pS := @s[idxS][1];
    idxP := 0;
  end;

  procedure WritePeriod(nom:Int64;dom:LongInt);
  var
    remind  : Int64;
    quot,i : longInt;
  begin
    write(nom,'/',dom);
    quot := 0;
    if nom > dom then
    Begin
      quot := nom DIV dom;
      nom := nom -quot*dom;
    end;
    setlength(s,1);
    idxS := 0;
    s[idxS] := IntToStr(quot)+'.';
    idxP := length(s[idxS]);
    setlength(s[idxS],cLen);
    pS := @s[idxS][1];
    i := CheckMaxStartOfPeriod(dom);
    write(' Max start idx after "." = ',i);
    while i > 0 do
    Begin
      nom *=cbase;
      quot := nom DIV dom;
      nom -= dom*quot;
      pS[idxP] := chr(quot+Ord('0'));
      inc(idxP);// always < cLen
      dec(i);
      if (nom = 0)then
        BREAK;
    end;
    remind := nom;

    i := 0;
    while (nom<>0) do
    begin
      inc(i);
      nom *=cbase;
      quot := nom DIV dom;
      nom -= dom*quot;
      pS[idxP] := chr(quot+Ord('0'));
      inc(idxP);
      if idxP = cLen then
        Xtend;
      if (nom = remind) then
        BREAK;
    end;
    if nom <> 0 then
      write('  length of period : ',i);
    writeln;
    setlength(s[idxS],idxP);
    if idxS > 0 then
    Begin
      writeln(s[0]);
      if idxS>1 then
      begin
        s[idxS-1] += s[idxS];
        s[idxS] := copy(s[idxS-1],length(s[idxS-1])-cLen+1,cLen);
        writeln('..');
      end;
    end;
    writeln(s[idxS]);

    //delete
    for i := idxs downto 0 do
      setlength(s[i],0);
    setlength(s,0);
  end;

var
  i : longint;
BEGIN
  For i := Low(cTestVal) to High(cTestVal) do
  Begin
    WritePeriod(1,cTestVal[i]);
    writeln;
  end;
END.

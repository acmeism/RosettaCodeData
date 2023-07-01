program StrAdd;
{$Mode Delphi}
{$Optimization ON}
uses
  sysutils;//IntToStr

const
  maxCntOct = (SizeOf(NativeUint)*8+(3-1)) DIV 3;

procedure IntToOctString(i: NativeUint;var res:Ansistring);
var
  p : array[0..maxCntOct] of byte;
  c,cnt: LongInt;
begin
  cnt := maxCntOct;
  repeat
    c := i AND 7;
    p[cnt] := (c+Ord('0'));
    dec(cnt);
    i := i shr 3;
  until (i = 0);
  i := cnt+1;
  cnt := maxCntOct-cnt;
  //most time consuming with Ansistring
  //call fpc_ansistr_unique
  setlength(res,cnt);
  move(p[i],res[1],cnt);
end;

procedure IncStr(var s:String;base:NativeInt);
var
  le,c,dg:nativeInt;
begin
  le := length(s);
  IF le = 0 then
  Begin
    s := '1';
    EXIT;
  end;

  repeat
    dg := ord(s[le])-ord('0') +1;
    c  := ord(dg>=base);
    dg := dg-(base AND (-c));
    s[le] := chr(dg+ord('0'));
    dec(le);
  until (c = 0) or (le<=0);

  if (c = 1) then
  begin
    le := length(s);
    setlength(s,le+1);
    move(s[1],s[2],le);
    s[1] := '1';
  end;
end;

const
  MAX = 8*8*8*8*8*8*8*8*8;//8^9
var
  sOct,
  s  : AnsiString;
  i : nativeInt;
  T1,T0: TDateTime;
Begin
  sOct := '';
  For i := 1 to 16 do
  Begin
    IncStr(sOct,8);
    writeln(i:10,sOct:10);
  end;
  writeln;

  For i := 1 to 16 do
  Begin
    IntToOctString(i,s);
    writeln(i:10,s:10);
  end;

  sOct := '';
  T0 := time;
  For i := 1 to MAX do
    IncStr(sOct,8);
  T0 := (time-T0)*86400;
  writeln(sOct);

  T1 := time;
  For i := 1 to MAX do
    IntToOctString(i,s);
  T1 := (time-T1)*86400;
  writeln(s);
  writeln;
  writeln(MAX);
  writeln('IncStr         ',T0:8:3);
  writeln('IntToOctString ',T1:8:3);
end.

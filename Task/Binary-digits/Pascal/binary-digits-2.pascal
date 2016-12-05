program IntToPcharTest;
uses
  sysutils;//for timing

const
{$ifdef CPU64}
  cBitcnt = 64;
{$ELSE}
  cBitcnt = 32;
{$ENDIF}

procedure IntToBinPchar(AInt : NativeUInt;s:pChar);
//create the Bin-String
//!Beware of endianess ! this is for little endian
const
  IO : array[0..1] of char = ('0','1');//('_','X'); as you like
  IO4 : array[0..15] of LongWord = // '0000','1000' as LongWord
($30303030,$31303030,$30313030,$31313030,
 $30303130,$31303130,$30313130,$31313130,
 $30303031,$31303031,$30313031,$31313031,
 $30303131,$31303131,$30313131,$31313131);
var
  i : NativeInt;

begin
  IF AInt > 0 then
  Begin
  // Get the index of highest set bit
{$ifdef CPU64}
    i := BSRQWord(NativeInt(Aint))+1;
{$ELSE}
    i := BSRDWord(NativeInt(Aint))+1;
{$ENDIF}
    s[i] := #0;
    //get 4 characters at once
    dec(i);
    while i >= 3 do
    Begin
      pLongInt(@s[i-3])^ := IO4[Aint AND 15];
      Aint := Aint SHR 4;
      dec(i,4)
    end;
    //the rest one by one
    while i >= 0 do
    Begin
      s[i] := IO[Aint AND 1];
      AInt := Aint shr 1;
      dec(i);
    end;
  end
  else
  Begin
    s[0] := IO[0];
    s[1] := #0;
  end;
end;

procedure Binary_Digits;
var
 s: pCHar;
begin
  GetMem(s,cBitcnt+4);
  fillchar(s[0],cBitcnt+4,#0);
  IntToBinPchar(   5,s);writeln('   5: ',s);
  IntToBinPchar(  50,s);writeln('  50: ',s);
  IntToBinPchar(9000,s);writeln('9000: ',s);
  IntToBinPchar(NativeUInt(-1),s);writeln('  -1: ',s);
  FreeMem(s);
end;

const
  rounds = 10*1000*1000;

var
  s: pChar;
  t :TDateTime;
  i,l,cnt: NativeInt;
  Testfield : array[0..rounds-1] of NativeUint;
Begin
  randomize;
  cnt := 0;
  For i := rounds downto  1 do
  Begin
    l := random(High(NativeInt));
    Testfield[i] := l;
  {$ifdef CPU64}
    inc(cnt,BSRQWord(l));
  {$ELSE}
    inc(cnt,BSRQWord(l));
  {$ENDIF}
  end;
  Binary_Digits;
  GetMem(s,cBitcnt+4);
  fillchar(s[0],cBitcnt+4,#0);
  //warm up
  For i := 0 to rounds-1 do
    IntToBinPchar(Testfield[i],s);
  //speed test
  t := time;
  For i := 1 to rounds do
    IntToBinPchar(Testfield[i],s);
  t := time-t;
  Write(' Time ',t*86400.0:6:3,' secs, average stringlength ');
  Writeln(cnt/rounds+1:6:3);
  FreeMem(s);
end.

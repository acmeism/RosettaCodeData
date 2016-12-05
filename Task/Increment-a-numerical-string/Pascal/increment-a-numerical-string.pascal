program StrInc;
{$IFDEF FPC}
  {$Mode Delphi}
  {$Optimization ON}{$Align 16}{$Codealign proc=16,loop=4}
{$ENDIF}

uses
  sysutils;

type
  myString =  AnsiString; // string[32];//

function InCLoop(ps: pChar;le,Base: NativeInt):NativeInt;
//Add 1 and correct carry
//returns 0, if no overflow, else -1
var
  dg: nativeInt;
Begin
  dec(le);//ps is 0-based
  repeat
    dg := ord(ps[le])+(-ord('0')+1);
    result  := -ord(dg>=base);// -1 or 0 -> $FF...FF or $00...00
    ps[le] := chr(-(result AND base)+dg+ord('0'));
    dec(le);
  until (result = 0) or (le<0);
end;

procedure IncIntStr(base:NativeInt;var s:myString);
var
  le :nativeInt;
begin
  le := length(s);
  IF le > 0 then
  Begin
    if (InCLoop(pChar(@s[1]),le,base) <>0) then
    begin
      setlength(s,le+1);
      move(s[1],s[2],le);
      s[1] := '1';
    end
  end
  else
  Begin
    setlength(s,1);
    s[1] := '1';
  end;
end;

const
  strLen = 26;
  MAX = 1 shl strLen -1;

var
  s  : myString;
  i,base : nativeInt;
  T1,T0: TDateTime;
Begin
  For base := 2 to 10 do
  Begin
    s:= '';
{
    //Zero pad string
    //s:= '0';// doesn't work for AnsiString for FPC 3.0 but for 2.6.4?
    //This works for all Ansi-string
    setlength(s,strLen);fillchar(s[1],strLen,'0');
}
    T0 := time;
    For i := 1 to MAX do
      IncIntStr(Base,s);
    T0 := (time-T0)*86400;
    writeln(s:strLen,' base ',base:2,T0:8:3,' s');
//One Billion Digits
  setlength(s,1000*1000*1000+1);
  s[1]:= '0';//don't measure setlength in IncIntStr
  fillchar(s[2],length(s)-1,'9');
  writeln('first 5 digits ',s[1],s[2],s[3],s[4],s[5]);
  T0 := time;
  IncIntStr(s,10);
  T0 := (time-T0)*86400;
  writeln(length(s):10,T0:8:3,' s');
  writeln('first 5 digits ',s[1],s[2],s[3],s[4],s[5]);
  end;
end.

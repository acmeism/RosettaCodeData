program StrInc;
//increments a positive numerical string in different bases.
//the string must be preset with a value, length >0 ;
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$IFDEF FPC}
  {$Mode Delphi} {$Optimization ON,ALL}{$Align 32}
  uses
    sysutils;
{$ELSE}
  uses
    system.SysUtils;
{$ENDIF}
type
  myString =  AnsiString; // String[32];//

function IncLoop(ps: pChar;le,Base: NativeInt):NativeInt;inline;
//Add 1 and correct carry
//returns 0, if no overflow, else 1
var
  dg: nativeInt;
Begin
  dec(le);//ps is 0-based
  dg := ord(ps[le])+(-ord('0')+1);
  result := 0;

  repeat
    IF dg < base then
    begin
      ps[le] := chr(dg+ord('0'));
      EXIT;
    end;
    ps[le] := '0';
    dec(le);
    dg := ord(ps[le])+(-ord('0')+1);
  until (le<0);
  result:= 1;
end;

procedure IncIntStr(base:NativeInt;var s:myString);
var
  le: NativeInt;
begin
  le := length(s);
  //overflow -> prepend a '1' to string
  if (IncLoop(pChar(@s[1]),le,base) <>0) then
  Begin
//    s := '1'+s;
    setlength(s,le+1);
    move(s[1],s[2],le);
    s[1] := '1';
  end;
end;

const
  ONE_BILLION = 1000*1000*1000;
  strLen = 26;
  MAX = 1 shl strLen -1;

var
  s  : myString;
  i,base : nativeInt;
  T0: TDateTime;
Begin
  writeln(MAX,' increments in base');
  For base := 2 to 10 do
  Begin
    //s := '0' doesn't work
    setlength(s,1);
    s[1]:= '0';
{   //Zero pad string
    setlength(s,strLen);fillchar(s[1],strLen,'0');
}
    T0 := time;
    For i := 1 to MAX do
      IncIntStr(Base,s);
    T0 := (time-T0)*86400;
    writeln(s:strLen,' base ',base:2,T0:8:3,' s');
  end;

  writeln;
  writeln('One billion digits "9"');
  setlength(s,ONE_BILLION+1);
  s[1]:= '0';//don't measure setlength in IncIntStr
  fillchar(s[2],length(s)-1,'9');
  writeln('first 5 digits ',s[1],s[2],s[3],s[4],s[5]);
  T0 := time;
  IncIntStr(10,s);
  T0 := (time-T0)*86400;
  writeln(length(s):10,T0:8:3,' s');
  writeln('first 5 digits ',s[1],s[2],s[3],s[4],s[5]);
  s:='';
  {$IFDEF WINDOWS}
    readln;
  {$ENDIF}
end.

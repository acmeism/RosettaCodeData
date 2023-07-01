program AgmForPi;
{$mode objfpc}{$h+}{$b-}{$warn 5091 off}
uses
  SysUtils, Math, GMP;

const
  MIN_DIGITS = 32;
  MAX_DIGITS = 1000000;

var
  Digits: Cardinal = 256;

procedure ReadInput;
var
  UserDigits: Cardinal;
begin
  if (ParamCount > 0) and TryStrToDWord(ParamStr(1), UserDigits) then
    Digits := Min(MAX_DIGITS, Max(UserDigits, MIN_DIGITS));
  f_set_default_prec(Ceil((Digits + 1)/LOG_10_2));
end;

function Sqrt(a: MpFloat): MpFloat;
begin
  Result := f_sqrt(a);
end;

function Sqr(a: MpFloat): MpFloat;
begin
  Result := a * a;
end;

function PiDigits: string;
var
  a0, b0, an, bn, tn: MpFloat;
  n: Cardinal;
begin
  n := 1;
  an := 1;
  bn := Sqrt(MpFloat(0.5));
  tn := 0.25;
  while n < Digits do begin
    a0 := an;
    b0 := bn;
    an := (a0 + b0)/2;
    bn := Sqrt(a0 * b0);
    tn := tn - Sqr(an - a0) * n;
    n := n + n;
  end;
  Result := Sqr(an + bn)/(tn * 4);
  SetLength(Result, Succ(Digits));
end;

begin
  ReadInput;
  WriteLn(PiDigits);
end.

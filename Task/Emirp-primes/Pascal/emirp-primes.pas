program Emirp;
//palindrome prime 13 <-> 31
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON}
  {$OPTIMIZATION REGVAR}
  {$OPTIMIZATION PEEPHOLE}
  {$OPTIMIZATION CSE}
  {$OPTIMIZATION ASMCSE}
  {$Smartlink ON}
  {$CODEALIGN proc=32}
{$ELSE}
  {$APPLICATION CONSOLE}
{$ENDIF}
uses
  primtrial,sysutils; //IntToStr
const
  helptext : array[0..5] of string =
     ('  usage ',
      '  t     -> test of functions',
      '  b l u -> Emirps betwenn l,u       b 7700 8000',
      '  c n   -> count of Emirps up to n  c 99999',
      '  f n   -> output n first Emirp     f 20',
      '  n     -> output the n.th Emirps   10000');

  StepToNextPrimeEnd : Array[0..9] of byte =
              (1,0,3,0,7,7,7,0,9,0);

  base = 10;

var
  s: AnsiString;
  pow,
  powLen  : NativeUint;

procedure OutputHelp;
var
  i : NativeUint;
Begin
  For i := Low(helptext) to High(helptext) do
    writeln(helptext[i]);
  writeln;
end;

function GetNumber(const s: string;var n:NativeUint):boolean;
var
  ErrCode: Word;
Begin
  val(s,n,Errcode);
  result := ErrCode = 0;
end;

procedure RvsStr(var s: AnsiString);
var
  i, j: NativeUint;
  swapChar : Ansichar;
Begin
  i := 1;
  j := Length(s);
  While j>i do Begin
    swapChar:= s[i];s[i] := s[j];s[j] := swapChar;
    inc(i);dec(j) end;
end;

function RvsNumL(var n: NativeUint):NativeUint;
//reverse and last digit
var
  q, c: NativeUint;
Begin
  result := n;
  q := 0;
  repeat
    c:= result div Base;
    q := q*Base+(result-c*Base);
    result := c;
  until result < Base;
  n := q*Base+result;

end;

procedure InitP(var p: NativeUint);
Begin
  powLen := 2;
  pow := Base;
  InitPrime;
  repeat p :=NextPrime until p >= 11;
end;

function isEmirp(p: NativeUint):boolean;
var
  rvsp: NativeUint;
Begin
  s := IntToStr(p);
  result := StepToNextPrimeEnd[Ord(s[1])-48] = 0;
  IF result then
  Begin
    RvsStr(s);
    rvsp := StrToInt(s);
    result := false;
    IF rvsp<>p then
      result := isPrime(rvsp);
  end;
end;

function NextEmirp:NativeUint;
var
 r,Ldgt: NativeUint;
Begin
  result:= NextPrime;
  repeat
    r := result;
    //reverse
    Ldgt := RvsNumL(r);
    Ldgt := StepToNextPrimeEnd[Ldgt];
    IF Ldgt = 0 then
    Begin
      IF r<>result then
        IF isPrime(r) then
          EXIT;
      result:= NextPrime;
    end
    else
    Begin
      while actPrime > pow*Base do
      Begin
        inc(PowLen);
        pow := pow*base;
      end;
      result := Ldgt*pow;
      result := PrimeGELimit(result);
    end;
  until false;
end;

function GetIthEmirp(i: NativeUint):NativeUint;
var
  p : NativeUint;
Begin
  InitP(p);
  Repeat
    dec(i);
    p:= NextEmirp;
  until i = 0;
  result := p;
end;

procedure nFirstEmirp(n: NativeUint);
var
  p : NativeUint;

Begin
  InitP(p);
  Writeln('the first ',n,' Emirp primE: ');
  Repeat
    dec(n);
    p:= NextEmirp;
    write(p,' ');
  until n = 0;
  Writeln;
end;

function CntToLimit(n: NativeUint):NativeUint;
var
  p,cnt : NativeUint;
Begin
  cnt := 0;
  InitP(p);
  p:= NextEmirp;
  While p <= n do
  Begin
    inc(cnt);
    p:= NextEmirp;
  end;
  result := cnt;
end;

procedure InRange(l,u:NativeUint);
var
  p : NativeUint;
  b : boolean;
Begin
  InitP(p);
  IF l > u then Begin p:=l;l:=u;u:=p end;
  Writeln('Emirp primes between ',l,' and ',u,' : ');
  p := PrimeGELimit(l);

  b := IsEmirp(p);
  if b then
    write(p,' ');
  p:= NextEmirp;
  IF (p> u) AND NOT b  then
    Writeln('none')
  else
  Begin
    while p < u do
      Begin
      write(p,' ');
      p:= NextEmirp;
    end;
    Writeln;
  end;
end;

var
  i,u: NativeUint;
  select : char;
Begin
  IF paramcount >= 1 then
    select := Lowercase(paramstr(1)[1]);
  case paramcount of
  1: Begin
       if select='t' then
       Begin
         nFirstEmirp(20);
         InRange(7700,8000);
         Writeln('the ',10000,'.th Emirp prime: ',GetIthEmirp(10000));
         writeln(CntToLimit(9999),' Emirp primes up to ',9999);
         // as a gag
         InRange(400000000,700000000);
       end
       else
         IF GetNumber(paramstr(1),i) then
           Writeln('the ',i,'.th Emirp prime: ',GetIthEmirp(i))
         else
           OutPutHelp;
     end;
  2: Begin
       case select of
       'c': If GetNumber(paramstr(2),i) then
              writeln(CntToLimit(i),' Eemirp primes up to ',i)
            else
              OutPutHelp;
       'f': If GetNumber(paramstr(2),i) then
              nFirstEmirp(i)
            else
              OutPutHelp;
        else
          OutPutHelp;
        end;
     end;
  3: IF (select ='b') AND
        GetNumber(paramstr(2),i) AND GetNumber(paramstr(3),u) Then
       InRange(i,u)
     else
        OutPutHelp;
  else
    OutPutHelp;
  end;
End.

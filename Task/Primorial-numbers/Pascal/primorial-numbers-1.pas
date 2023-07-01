{$H+}
uses
  sysutils,mp_types,mp_base,mp_prime,mp_numth;
var
 x: mp_int;
 t0,t1: TDateTime;
 s: AnsiString;

var
  i,cnt : NativeInt;
  ctx :TPrimeContext;
begin
  mp_init(x);
  cnt := 1;
  i := 2;
  FindFirstPrime32(i,ctx);
  i := 10;
  t0 := time;
  repeat
    repeat
      FindNextPrime32(ctx);
      inc(cnt);
    until cnt = i;
    mp_primorial(ctx.prime,x);
    s:= mp_adecimal(x);
    writeln('MaxPrime ',ctx.prime:10,length(s):8,' digits');
    i := 10*i;
  until i > 1000*1000;
  t1 := time;
  Writeln((t1-t0)*86400.0:10:3,' s');
end.

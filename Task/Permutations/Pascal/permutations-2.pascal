{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
type
  tPermfield  =  array[0..15] of Nativeint;
var
  permcnt: NativeUint;

procedure DoSomething(k: NativeInt;var x:tPermfield);
var
  i:integer;
  kk:string;
begin
  kk:='';
  for i:=1 to k do kk:=kk+inttostr(x[i])+' ';
    writeln(kk);
end;

procedure PermKoutOfN(k,n: nativeInt);
var
  x,y:tPermfield;
  i,yi,tmp:NativeInt;
begin
  //initialise
  permcnt:= 1;
  if k>n then
    k:=n;
  if k=n then
    k:=k-1;
  for i:=1 to n do x[i]:=i;
  for i:=1 to k do y[i]:=i;

//  DoSomething(k,x);
  i := k;
  repeat
    yi:=y[i];
    if yi <n then
    begin
      inc(permcnt);
      inc(yi);
      y[i]:=yi;
      tmp:=x[i];x[i]:=x[yi];x[yi]:=tmp;
      i:=k;
//      DoSomething(k,x);
    end
    else
    begin
      repeat
        tmp:=x[i];x[i]:=x[yi];x[yi]:=tmp;
        dec(yi);
      until yi<=i;
      y[i]:=yi;
      dec(i);
    end;
  until (i=0);
end;

var
  t1,t0 : TDateTime;
Begin
  permcnt:= 0;
  T0 := now;
  PermKoutOfN(12,12);
  T1 := now;
  writeln(permcnt);
  writeln(FormatDateTime('HH:NN:SS.zzz',T1-T0));
end.

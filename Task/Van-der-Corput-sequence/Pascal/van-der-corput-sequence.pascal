Program VanDerCorput;
{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}

type
  tvdrCallback = procedure (nom,denom: NativeInt);

{ Base=2
function rev2(n,Pot:NativeUint):NativeUint;
var
  r : Nativeint;
begin
  r := 0;
  while Pot > 0 do
  Begin
    r := r shl 1 OR (n AND 1);
    n := n shr 1;
    dec(Pot);
  end;
  rev2 := r;
end;
}

function reverse(n,base,Pot:NativeUint):NativeUint;
var
  r,c : Nativeint;
begin
  r := 0;
//No need to test n> 0 in this special case, n starting in upper half
  while Pot > 0 do
  Begin
    c := n div base;
    r := n+(r-c)*base;
    n := c;
    dec(Pot);
  end;
  reverse := r;
end;

procedure VanDerCorput(base,count:NativeUint;f:tvdrCallback);
//calculates count nominater and denominater of Van der Corput sequence
// to base
var
 Pot,
 denom,nom,
 i : NativeUint;
Begin
  denom := 1;
  Pot := 0;
  while count > 0 do
  Begin
    IF Pot = 0 then
      f(0,1);
    //start in upper half
    i := denom;
    inc(Pot);
    denom := denom *base;

    repeat
      nom := reverse(i,base,Pot);
      IF count > 0 then
        f(nom,denom)
      else
        break;
      inc(i);
      dec(count);
    until i >= denom;
  end;
end;

procedure vdrOutPut(nom,denom: NativeInt);
Begin
  write(nom,'/',denom,'  ');
end;

var
 i : NativeUint;
Begin
  For i := 2 to 5 do
  Begin
    write(' Base ',i:2,' :');
    VanDerCorput(i,9,@vdrOutPut);
    writeln;
  end;
end.

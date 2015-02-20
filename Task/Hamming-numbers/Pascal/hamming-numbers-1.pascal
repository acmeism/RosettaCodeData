program HammNumb;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
{
type
  NativeUInt = longWord;
}
var
  pot   : array[0..2] of NativeUInt;

function NextHammNumb(n:NativeUInt):NativeUInt;
var
  q,p,nr : NativeUInt;
begin
  repeat
    nr := n+1;
    n := nr;

    p := 0;
    while NOT(ODD(nr)) do
    begin
      inc(p);
      nr := nr div 2;
    end;
    Pot[0]:= p;

    p := 0;
    q := nr div 3;
    while q*3=nr do
    Begin
      inc(P);
      nr := q;
      q := nr div 3;
    end;
    Pot[1] := p;

    p := 0;
    q := nr div 5;
    while q*5=nr do
    Begin
      inc(P);
      nr := q;
      q := nr div 5;
    end;
    Pot[2] := p;

  until nr = 1;
  result:= n;
end;

procedure Check;
var
  i,n: NativeUint;
begin
  n := 1;
  for i := 1 to 20 do
  begin
    n := NextHammNumb(n);
    write(n,' ');
  end;
  writeln;
  writeln;
  n := 1;
  for i := 1 to 1690 do
    n := NextHammNumb(n);
  writeln('No ',i:4,' | ',n,' = 2^',Pot[0],' 3^',Pot[1],' 5^',Pot[2]);
end;

Begin
  Check;
End.

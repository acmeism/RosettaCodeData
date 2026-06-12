program PermuWithRep;
//permutations with repetitions
//http://rosettacode.org/wiki/Permutations_with_repetitions
{$IFDEF FPC}
  {$Mode Delphi}{$Optimization ON}{$Align 16}{$Codealign proc=16,loop=4}
{$ELSE}
  {$APPTYPE CONSOLE}// for Delphi
{$ENDIF}
uses
  sysutils;
type
  tPermData =  record
               mdTup_n,           //number of positions
               mdTup_k:NativeInt; //number of different elements
               mdTup :array of integer;
             end;

function InitTuple(k,n:nativeInt):tPermData;
begin
  with result do
  Begin
    IF k> 0 then
    Begin
      mdTup_k:= k;
      setlength(mdTup,k);
      IF (n<0) then
        mdTup_n := 0
      else
        mdTup_n := n;
    end
    else
    Begin
      mdTup_k := 1;
      mdTup_n := k;
    end;
  end;
end;

procedure PermOut(const p:tPermData);
var
  i : nativeInt;
Begin
  with p do
  Begin
    For i := 0 to mdTup_k-1 do
      write(mdTup[i]:4);
  end;
  writeln;
end;

function NextPermWithRep(var perm:tPermData): boolean;
// create next permutation by adding 1 and correct "carry"
// returns false if finished
var
  pDg :^Integer;
  dg,le :nativeInt;
begin
  WIth perm do
  Begin
    pDg := @mdTup[0];
    le := mdTup_k;
    repeat
      dg := pDg^+1;
      IF (dg<mdTup_n) then
      Begin
        pDg^ := dg;
        BREAK;
      end
      else
        pDg^  := 0;
     dec(le);
     inc(pDg);
    until  le<=0;
    result := (dg<mdTup_n);
  end;
end;

var
  p: tPermData;
  cnt,k,n: nativeInt;
Begin
  cnt := 0;
  //k := 2;n := 3;
  k := 10;n := 8;
  p:= InitTuple(k,n);
  IF (n<= 6) then
    repeat
      inc(cnt);
      PermOut(p);
    until Not(NextPermWithRep(p))
  else
    repeat
      inc(cnt);
    until Not(NextPermWithRep(p));
  writeln('k: ',k,' n: ',n,'  count ',cnt);
end.

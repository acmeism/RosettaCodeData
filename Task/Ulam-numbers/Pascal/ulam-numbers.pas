program UlamNumbers;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$Optimization On,All}
{$ENDIF}
uses
  sysutils;
const
  maxUlam = 100000;
  Limit = 1351223+4000;
type
  tCheck  =  Uint16;
  tpCheck = pUint16;
var
  Ulams : array of Uint32;
  Check0 : array of tCheck;
  Ulam_idx :NativeInt;

procedure init;
begin
  setlength(Ulams,maxUlam);
  Ulams[0] := 1;
  Ulams[1] := 2;
  Ulam_idx := 1;
  setlength(check0,Limit);

  check0[1]:=1;
  check0[2]:=1;
end;

procedure OutData(idx,num:NativeInt);
Begin
  writeln(' Ulam(',idx+1,')',#9#9,num:10);
end;

function findNext(i:nativeInt;pCh0:tpCheck):NativeInt;
begin
  result := i;
  repeat
    if pCh0[result] = 1 then
      break;
    inc(result);
  until false;
end;

procedure SumOne(idx:NativeUint;pCh:tpCheck;pUlams:pUint32);
//seperated speeds up a lot by reducing register pressure in main
Begin
  For idx := idx downto 0 do
    pCh[pUlams[idx]] +=1;
end;

var
  pCh0,pCh : tpCheck;
  pUlams   : pUint32;
  ul,idx,lmtidx :nativeInt;
Begin

  Init;
  lmtidx := 9;
  pCh0:= @Check0[0];
  pUlams := @Ulams[0];
  OutData(0,pUlams[0]);
  ul := pUlams[Ulam_idx];
  pCh:= @pCh0[ul];
  repeat
    SumOne(Ulam_idx-1,pCh,pUlams);
    ul := findNext(ul+1,pCh0);
    inc(Ulam_idx);
    pUlams[Ulam_idx] := ul;
    pCh:= @pCh0[ul];
    IF ul>Limit DIV 2 then
      break;
    if Ulam_idx=lmtIdx then
    Begin
      OutData(Ulam_idx,ul);
      lmtidx := lmtidx*10+9;
    end;
  until Ulam_idx >= maxUlam-1;

  idx := Ulam_idx-1;
  //now reducing then the highest used summing idx
  while Ulam_idx< maxUlam-1 do
  begin
    while ul+pUlams[idx] > limit do
      dec(idx);
    SumOne(idx,pCh,pUlams);
    ul := findNext(ul+1,pCh0);
    inc(Ulam_idx);
    pUlams[Ulam_idx] := ul;
    pCh:= @pCh0[ul];
  end;
  OutData(Ulam_idx,ul);
  setlength(check0,0);
  setlength(Ulams,0);
end.

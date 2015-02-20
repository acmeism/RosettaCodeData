program NdN;
//Narcissistic decimal number
const
  Base = 10;
  MaxDigits = 16;
type
  tDigit = 0..Base-1;
  tcntDgt= 0..MaxDigits-1;
var
  powDgt   : array[tDigit]  of NativeUint;
  PotdgtPos: array[tcntDgt] of NativeUint;
  UpperSum : array[tcntDgt] of NativeUint;

  tmpSum,
  tmpN,
  actPot  : NativeUint;

procedure InitPowDig;
var
  i,j : NativeUint;
Begin
  j := 1;
  For i := 0 to High(tDigit) do
  Begin
    powDgt[i] := i;
    PotdgtPos[i] := j;
    j := j*Base;
  end;
  actPot := 0;
end;

procedure NextPowDig;
var
  i,j : NativeUint;
Begin
  // Next power of digit =  i ^ actPot,always 0 = 0 , 1 = 1
  For i := 2 to High(tDigit) do
    powDgt[i] := powDgt[i]*i;
  // number of digits times 9 ^(max number of digits)
  j := powDgt[High(tDigit)];
  For i := 0 to High(UpperSum) do
    UpperSum[i] := (i+1)*j;
  inc(actPot);
end;
procedure OutPutNdN(n:NativeUint);
Begin
  write(n,' ');
end;

procedure NextDgtSum(dgtPos,i,sumPowDgt,n:NativeUint);
begin
  //unable to reach sum
  IF (sumPowDgt+UpperSum[dgtPos]) < n then
    EXIT;
  repeat
    tmpN   := n+PotdgtPos[dgtPos]*i;
    tmpSum := sumPowDgt+powDgt[i];
    //unable to get smaller
    if tmpSum > tmpN then
      EXIT;
    IF tmpSum = tmpN then
      OutPutNdN(tmpSum);
    IF dgtPos>0 then
      NextDgtSum(dgtPos-1,0,tmpSum,tmpN);
    inc(i);
  until i >= Base;
end;

var
  i : NativeUint;
Begin
  InitPowDig;
  For i := 1 to 9 do
  Begin
    write(' length ',actPot+1:2,': ');
    //start with 1 in front, else you got i-times 0 in front
    NextDgtSum(actPot,1,0,0);
    writeln;
    NextPowDig;
  end;
end.

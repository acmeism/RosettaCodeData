program  Probablistic;
const
  rounds = 1000*1000;
  names : array[0..7] of string =('aleph','beth','gimel','daleth','he','waw','zayin','heth');
  quotient = 5*6*7*8*9*10*11;
  RezValues: array[0..7] of integer=(5,6,7,8,9,10,11,0);
//remaining heth   = 27720/1759

function GCD(a, b: Int64): Int64;
var
  temp: Int64;
begin
  while b <> 0 do
  begin
    temp := b;
    b := a mod b;
    a := temp
  end;
  Exit(a);
end;

var
  cnt : array of Uint32;
  i ,z,n,tmp,idx,lmt : NativeInt;
  sumTot : NativeUint;
begin
  randomize;
  z := 0;
  n := 1;
  For i := 0 to 6 do
  begin
    z := z*RezValues[i]+n;
    n := n*RezValues[i];
    tmp := GCD(z,n);
    z := z div tmp;
    n := n div tmp;
  end;

  //create the values
  setlength(cnt,n+1);
  For i := 1 to rounds do
    inc(cnt[trunc(random()*n)]);
  //count occurences in range
  writeln('Item':9,'expected':10,'actual':10);
  sumTot := 0;
  idx := 0;
  lmt := 0;
  For i := 0 to 6 do
  begin
    lmt += n DIV RezValues[i];
    tmp := 0;
    repeat
      inc(tmp,cnt[idx]);
      inc(idx);
    until idx >= lmt;
    sumTot += tmp;
    writeln(names[i]:9,1/RezValues[i]:10:6,tmp/rounds:10:6);
  end;
  //the remaining for heth
  writeln(names[7]:9,(n-z)/n:10:6,1-sumTot/rounds:10:6);
end.

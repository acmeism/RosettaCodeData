program pythQuad;
//find phythagorean Quadrupel up to a,b,c,d <= 2200
//a^2 + b^2 +c^2 = d^2
//find all values of d which are not possible
//brute force
//split in two procedure to reduce register pressure for CPU32

const
  MaxFactor =2200;
  limit = MaxFactor*MaxFactor;
type
  tIdx = NativeUint;
  tSum = NativeUint;

var
  check : array[0..MaxFactor] of boolean;
  checkCnt : LongWord;

procedure Find2(s:tSum;idx:tSum);
//second sum (a*a+b*b) +c*c =?= d*d
var
  s1 : tSum;
  d : tSum;
begin
  d := trunc(sqrt(s+idx*idx));// calculate first sqrt
  For idx := idx to MaxFactor do
  Begin
    s1 := s+idx*idx;
    If s1 <= limit then
    Begin
      while s1 > d*d do //adjust sqrt
        inc(d);
      inc(checkCnt);
      IF s1=d*d then
        check[d] := true;
    end
    else
      Break;
  end;
end;

procedure Find1;
//first sum a*a+b*b
var
  a,b : tIdx;
  s : tSum;
begin
  For a := 1 to MaxFactor do
    For b := a to MaxFactor do
    Begin
      s := a*a+b*b;
      if s < limit then
        Find1(s,b)
      else
        break;
     end;
end;

var
  i : NativeUint;
begin
  Find1;

  For i := 1 to MaxFactor do
    If Not(Check[i]) then
      write(i,' ');
  writeln;
  writeln(CheckCnt,' checks were done');
end.

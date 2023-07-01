function totient(n:NativeUInt):NativeUInt;
const
  //delta of numbers not divisible by 2,3,5 (0_1+6->7+4->11 ..+6->29+2->3_1
  delta : array[0..7] of NativeUint = (6,4,2,4,2,4,6,2);
var
  i, quot,idx: NativeUint;
Begin
  // div mod by constant is fast.
  //i = 2
  result := n;
  if (2*2 <= n) then
  Begin
    IF not(ODD(n)) then
    Begin
      // remove numbers with factor 2,4,8,16, ...
      while not(ODD(n)) do
        n := n DIV 2;
      //remove count of multiples of 2
      dec(result,result DIV 2);
    end;
  end;
  //i = 3
  If (3*3 <= n) AND (n mod 3 = 0) then
  Begin
    repeat
      quot := n DIV 3;
      IF n <> quot*3 then
        BREAK
      else
        n := quot;
    until false;
    dec(result,result DIV 3);
  end;
  //i = 5
  If (5*5 <= n) AND (n mod 5 = 0) then
  Begin
    repeat
      quot := n DIV 5;
      IF n <> quot*5 then
        BREAK
      else
        n := quot;
    until false;
    dec(result,result DIV 5);
  end;
  i := 7;
  idx := 1;
  //i = 7,11,13,17,19,23,29, ...49 ..
  while i*i <= n do
  Begin
    quot := n DIV i;
    if n = quot*i then
    Begin
      repeat
        IF n <> quot*i then
          BREAK
        else
          n := quot;
        quot := n DIV i;
      until false;
      dec(result,result DIV i);
    end;
    i := i + delta[idx];
    idx := (idx+1) AND 7;
  end;
  if n> 1 then
    dec(result,result div n);
end;

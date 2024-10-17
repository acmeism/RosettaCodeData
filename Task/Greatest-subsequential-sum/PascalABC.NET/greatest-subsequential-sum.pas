function MaxSumSeq(a: array of integer): (integer,integer,integer);
begin
  var (maxSum,thisSum) := (0,0);
  var (f,t) := (0,-1);
  var k := 0;
  for var j:=0 to a.Length-1 do
  begin
    thisSum += a[j];
    if thisSum < 0 then
    begin
      k := j + 1;
      thisSum := 0;
    end
    else if thisSum > maxSum then
    begin
      maxSum := thisSum;
      f := k;
      t := j
    end;
  end;
  Result := (f,t,maxSum);
end;

begin
  var a := Arr(-1 , -2 , 3 , 5 , 6 , -2 , -1 , 4 , -4 , 2 , -1);
  var (f,t,max) := MaxSumSeq(a);
  Print('Subsequence with max sum:', a[f:t+1], 'It''s sum:', max);
end.

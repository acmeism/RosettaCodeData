program abundodd(output);

  (* Abundant odd numbers *)

var
  oddnumber, acount, dsum: integer;
  found: boolean;

  (* returns the sum of the proper divisors of n *)
  function divisorsum(n: integer): integer;
  var
    sum, d, otherd: integer;
  begin
    sum := 1;
    for d := 2 to trunc(sqrt(n)) do
      if n mod d = 0 then
      begin
        sum := sum + d;
        otherd := n div d;
        if otherd <> d then
          sum := sum + otherd;
      end;
    divisorsum := sum;
  end;

begin
  (* first 25 odd abundant numbers *)
  oddnumber := 1;
  acount := 0;
  dsum := 0;
  writeln('The first 25 abundant odd numbers:');
  while acount < 25 do
  begin
    dsum := divisorsum(oddnumber);
    if dsum > oddnumber then
    begin
      acount := acount + 1;
      writeln(oddnumber: 6, ' proper divisor sum: ', dsum: 6);
    end;
    oddnumber := oddnumber + 2;
  end;

  (* 1000th odd abundant number - requires 32-bit integer *)
  while acount < 1000 do
  begin
    dsum := divisorsum(oddnumber);
    if dsum > oddnumber then
      acount := acount + 1;
    oddnumber := oddnumber + 2;
  end;
  writeln('1000th abundant odd number:');
  writeln('    ', oddnumber - 2: 1, ' proper divisor sum: ', dsum: 1);
  (* first odd abundant number > 1000000000  - requires 32-bit integer *)
  oddnumber := 1000000001;
  found := false;
  while not found do
  begin
    dsum := divisorsum(oddnumber);
    if dsum > oddnumber then
    begin
      found := true;
      writeln('First abundant odd number > 1 000 000 000:');
      writeln('    ', oddnumber: 1, ' proper divisor sum: ', dsum: 1);
    end;
    oddnumber := oddnumber + 2;
  end;
  (* readln; *)
end.

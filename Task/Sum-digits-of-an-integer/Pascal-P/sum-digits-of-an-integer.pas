program sumofdigits(output);
(* Sum digits of an integer *)

  function sumofdigitsbase(n: integer; base: integer): integer;
  var
    tmp: integer;
    digit, sum: integer;
  begin
    digit := 0;
    sum := 0;
    while n > 0 do
    begin
      tmp := n div base;
      digit := n - base * tmp;
      n := tmp;
      sum := sum + digit;
    end;
    sumofdigitsbase := sum;
  end;

begin
  writeln('   1 sums to ', sumofdigitsbase(1, 10));
  writeln('1234 sums to ', sumofdigitsbase(1234, 10));
  writeln(' $FE sums to ', sumofdigitsbase(254, 16)); (* $FE = 254 *)
  writeln('$FOE sums to ', sumofdigitsbase(3854, 16)); (* $FOE = 3854 *)
  (* readln; *)
end.

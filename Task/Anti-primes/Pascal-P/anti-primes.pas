program antiprimes(output);

  (* Anti-primes *)
  (* Very slow *)
var
  counter, max, num, dv, cnt: integer;
  enough: boolean;
begin
  counter := 0;
  max := 0;
  num := 1;
  enough := false;
  while not enough do
  begin
    cnt := 0;
    dv := 1;
    repeat
      if num mod dv = 0 then
        cnt := cnt + 1;
      dv := dv + 1;
    until dv > num;
    if cnt > max then
    begin
      write(num: 5);
      max := cnt;
      counter := counter + 1;
      if counter >= 20 then
        enough := true;
    end;
    num := num + 1;
  end;
  writeln;
  (* readln; *)
end.

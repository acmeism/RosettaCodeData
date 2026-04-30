program primdecomp(input, output);
  (* Prime decomposition *)
const
  maxfacindex = 30;
  (* -(2^31) has most prime factors (31 twos) than other 32-bit signed integer.
  *)
type
  tfacs = array[0 .. maxfacindex] of integer;
var
  i, n, cnt: integer;
  facs: tfacs;

  function facscnt(n: integer; var facs: tfacs): integer;
  var
    i, cnt: integer;
  begin
    n := abs(n);
    cnt := 0;
    if n >= 2 then
    begin
      i := 2;
      while i * i <= n do
      begin
        if n mod i = 0 then
        begin
          n := n div i;
          facs[cnt] := i;
          cnt := cnt + 1;
          i := 2;
        end
        else
          i := i + 1;
      end;
      facs[cnt] := n;
      cnt := cnt + 1;
    end;
    facscnt := cnt;
  end;

begin
  write('Enter a number: ');
  read(n);
  cnt := facscnt(n, facs);
  for i := 0 to cnt - 2 do write(facs[i]:1, ' ');
  writeln(facs[cnt - 1]:1);
  (* readln; *)
end.

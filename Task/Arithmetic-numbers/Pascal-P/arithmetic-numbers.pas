program arithmnums(output);

  (* Arithmetic numbers *)
var
  n, arithmcnt, compcnt: integer;
  dv, dvcnt, sum, quot: integer;
  isdone: boolean;
begin
  n := 1;
  arithmcnt := 0;
  compcnt := 0;
  writeln('The first 100 arithmetic numbers are:');
  while arithmcnt < 10001 do
    (* in the case of 16-bit integers set condition arithmcnt < 1001 *)
  begin
    dv := 1;
    dvcnt := 0;
    sum := 0;
    isdone := false;
    while not isdone do
    begin
      quot := n div dv;
      if quot < dv then
        isdone := true
      else
      begin
        if (quot = dv) and (n mod dv = 0) then
        begin (* n is a square *)
          sum := sum + quot;
          dvcnt := dvcnt + 1;
          isdone := true;
        end
        else
        begin
          if n mod dv = 0 then
          begin
            sum := sum + dv + quot;
            dvcnt := dvcnt + 2;
          end;
          dv := dv + 1;
        end;
      end;
    end;
    if sum mod dvcnt = 0 then
    begin (* n is arithmetic *)
      arithmcnt := arithmcnt + 1;
      if arithmcnt <= 100 then
      begin
        write(n: 4);
        if arithmcnt mod 10 = 0 then
          writeln;
      end;
      if dvcnt > 2 then
        compcnt := compcnt + 1;
      if (arithmcnt = 1000) or (arithmcnt = 10000) then
      begin
        writeln;
        write('The ', arithmcnt: 5, 'th arithmetic number is ',
          n: 5, ' up to which ', compcnt: 5, ' are composite.');
      end;
    end;
    n := n + 1;
  end;
  writeln;
  (* readln; *)
end.

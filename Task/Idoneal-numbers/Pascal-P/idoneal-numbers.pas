program idoneals(output);
(* Idoneal numbers *)
var
  n, c: integer;

  function isidoneal(n: integer): boolean;
    (* Return 'true' if n is an Idoneal number *)
  var
    a, b, c, ab, s, t: integer;
    stat: (loopa, loopb, loopc, exitfun);
  begin
    a := 1;
    stat := loopa;
    while stat <> exitfun do
    begin
      case stat of
        loopa:
          if a <= n then
          begin
            b := a + 1;
            stat := loopb;
          end
          else
          begin
            isidoneal := true;
            stat := exitfun;
          end;
        loopb:
          if b <= n then
          begin
            ab := a * b;
            s := a + b;
            if ab + s > n then
            begin
              a := a + 1;
              stat := loopa;
            end
            else
            begin
              c := b + 1;
              stat := loopc;
            end;
          end
          else
          begin
            a := a + 1;
            stat := loopa;
          end;
        loopc:
          if c <= n then
          begin
            t := ab + c * s;
            if t = n then
            begin
              isidoneal := false;
              stat := exitfun;
            end
            else if t > n then
            begin
              b := b + 1;
              stat := loopb;
            end
            else
            begin
              c := c + 1;
              stat := loopc;
            end;
          end
          else
          begin
            b := b + 1;
            stat := loopb;
          end;
      end;
    end;
  end;

begin
  n := 1;
  c := 0;
  repeat
    if isidoneal(n) then
    begin
      write(n: 5);
      c := c + 1;
      if c mod 13 = 0 then
        writeln;
    end;
    n := n + 1;
  until c >= 65;
  (* readln; *)
end.

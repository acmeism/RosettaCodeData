// increments e step times until bal is greater than t
// repeats until bal = 1 (mod = 1) and returns count
// bal will not be greater than t + e

function modInv(e, t : integer) : integer;
  var
    d : integer;
    bal, count, step : integer;
  begin
    d := 0;
    if e < t then
      begin
        count := 1;
        bal := e;
        repeat
          step := ((t-bal) DIV e)+1;
          bal := bal + step * e;
          count := count + step;
          bal := bal - t;
        until bal = 1;
        d := count;
      end;
    modInv := d;
  end;

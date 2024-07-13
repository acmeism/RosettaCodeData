program countTheCoins;

{$mode objfpc}{$H+}

var
  count, quarter, dime, nickel, penny: integer;

begin
  count := 0;

  for penny := 0 to 100 do
    for nickel := 0 to 20 do
      for dime := 0 to 10 do
        for quarter := 0 to 4 do
          if (penny + 5 * nickel + 10 * dime + 25 * quarter = 100) then
          begin
            writeln(penny, ' pennies ', nickel, ' nickels ', dime, ' dimes ', quarter, ' quarters');
            count := count + 1;
          end;


  writeln('The number of ways to make change for a dollar is: ', count); // 242 ways to make change for a dollar

end.

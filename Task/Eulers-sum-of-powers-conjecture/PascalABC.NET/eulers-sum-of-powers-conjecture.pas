##
function eulers_sum_of_powers(): (integer, integer, integer, integer, integer);
begin
  var max_n := 250;
  var pow5_to_n := (0..250).Select(x -> (x ** 5, x)).ToDictionary(x -> x[0], x -> x[1]);
  var pow_5 := pow5_to_n.Select(x -> x.key).ToArray;
  for var x0 := 1 to max_n do
    for var x1 := 1 to x0 do
      for var x2 := 1 to x1 do
        for var x3 := 1 to x2 do
        begin
          var pow_5_sum := pow_5[x0] + pow_5[x1] + pow_5[x2] + pow_5[x3];
          if pow_5_sum in pow5_to_n then
          begin
            var y := pow5_to_n[pow_5_sum];
            result := (x0, x1, x2, x3, y);
            exit;
          end;
        end;
end;

var sol := eulers_sum_of_powers;
writeln(sol[0], '**5 + ', sol[1], '**5 + ', sol[2], '**5 + ', sol[3], '**5 = ', sol[4], '**5');

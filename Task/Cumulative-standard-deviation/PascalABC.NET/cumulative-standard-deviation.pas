##
function sdcreator(): real-> real;
begin
  var Sum := 0.0;
  var Sum2 := 0.0;
  var N := 0;

  result := function(x: real): real ->
  begin
    N += 1;
    Sum += x;
    Sum2 += x * x;
    result := sqrt(Sum2 / N - Sum * Sum / (N * N));
  end;
end;

var sd := sdcreator();

foreach var value in |2, 4, 4, 4, 5, 5, 7, 9| do
  println(value, sd(value));

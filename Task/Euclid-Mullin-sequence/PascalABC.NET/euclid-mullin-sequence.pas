function smallest_prime_factor(number: biginteger): biginteger;
begin
  var divisor := 3bi;
  repeat
    if (number mod divisor) = 0 then
    begin
      result := divisor;
      exit
    end;
    divisor += 2;
  until divisor * divisor > number;
  result := number;
end;

function euclid_mullin(): sequence of biginteger;
begin
  var product := 2bi;
  yield product;
  while true do
  begin
    var smallest_prime := smallest_prime_factor(product + 1);
    product *= smallest_prime;
    yield smallest_prime;
  end;
end;

begin
  euclid_mullin.take(16).println;
end.

##
function disariums: sequence of integer;
begin
  var n := 0;
  while true do
  begin
    var sum := 0.0;
    foreach var x in n.ToString.ToCharArray index i do
      sum := sum + power((x.todigit), i + 1);
    if sum = n then yield (n);
    n += 1;
  end;
end;

disariums.Take(19).Println;

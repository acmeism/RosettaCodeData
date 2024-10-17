uses NumLibABC;

const
  max = 1 shl 19;

begin
  for var candidate := 2 to max - 1 do
  begin
    var sum := frc(1, candidate);
    var max2 := candidate.Sqrt.Trunc;
    for var factor := 2 to max2 do
      if (candidate mod factor) = 0 then
        sum += frc(1, factor) + frc(1, candidate div factor);
    if sum = frc(1) then
      Writeln(candidate, ' is perfect');
  end;
end.

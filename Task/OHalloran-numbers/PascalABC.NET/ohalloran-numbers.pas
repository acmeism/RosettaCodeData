const
  M = 1000;      // Maximum area.
  N = M div 2;   // Maximum half area.

var
  isOHalloran := (0..N).Select(n -> true).ToArray;

begin
  foreach var length in 1..N do
    foreach var width in 1..length do
    begin
      var plw := length * width;
      if plw > N then break;
      var slw := length + width;
      foreach var height in 1..width do
      begin
        var halfArea := plw + height * slw;
        if halfArea > N then break;
        isOHalloran[halfArea] := false;
      end;
    end;

  println('All known O''Halloran numbers:');
  foreach var i in 3..N do
    if isOHalloran[i] then
      write(2 * i, ' ');
end.

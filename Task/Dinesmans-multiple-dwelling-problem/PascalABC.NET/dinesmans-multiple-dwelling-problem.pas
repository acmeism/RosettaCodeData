const
  Baker = 0; Cooper = 1; Fletcher = 2; Miller = 3; Smith = 4;
  names: array of string = ('Baker', 'Cooper', 'Fletcher', 'Miller', 'Smith');

begin
  var floors := arr(1..5);
  repeat
    if (floors[Baker] <> 5) and
       (floors[Cooper] <> 1) and
       (floors[Fletcher] not in [1, 5]) and
       (floors[Miller] > floors[Cooper]) and
       (abs(floors[Smith] - floors[Fletcher]) <> 1) and
       (abs(floors[Fletcher] - floors[Cooper]) <> 1) then
    begin
      foreach var floor in floors index person do
        println(names[person], 'lives on floor', floor);
      exit
    end;
  until not NextPermutation(floors);
  println('No solution found.');
end.

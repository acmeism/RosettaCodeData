function games(n: integer): (integer, integer);
begin
  var stay := 0;
  var switch := 0;
  loop n do
  begin
    var lst := lst(1, 0, 0);  // one car and two goats
    lst.shuffle;              // shuffles the list randomly
    var ran := Random(3);     // gets a random number for the random guess
    var user := lst[ran];     // storing the random guess
    lst.RemoveAt(ran);        // deleting the random guess

    var huh := 0;
    foreach var i in lst do
    begin                     // getting a value 0 and deleting it
      if i = 0 then
      begin
        lst.RemoveAt(huh);    // deletes a goat when it finds it
        break
      end;
      huh += 1;
    end;

    if user = 1 then          // if the original choice is 1 then stay adds 1
      stay += 1;

    if lst[0] = 1 then        // if the switched value is 1 then switch adds 1
      switch += 1;
  end;
  result := (stay, switch);
end;

begin
  var (stay, switch) := games(1000);
  println('Stay = ', stay);
  println('Switch = ', switch);
end.

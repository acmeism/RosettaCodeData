const
  cutOff = 200;
  bigUn = 100000;
  chunks = 50;
  little = bigUn div chunks;

begin
  writeln('The first ', cutOff, ' cuban primes:');
  var primes := |int64(3), int64(5)|.ToList;
  var c := 0;
  var u: int64 := 0;
  var v: int64 := 1;
  var showEach := true;
  while true do
  begin
    var found := false;
    u += 6;
    v += u;
    var mx := real(v).sqrt.ceil;
    foreach var item in primes do
    begin
      if item > mx then break;
      if v mod item = 0 then
      begin
        found := true;
        break
      end;
    end;
    if not found then
    begin
      c += 1;
      if showEach then
      begin
        for var z := primes.last + 2 to v - 2 step 2 do
        begin
          var fnd := false;
          foreach var item in primes do
          begin
            if item > mx then break;
            if z mod item = 0 then
            begin
              fnd := true;
              break
            end;
          end;
          if not fnd then primes.Add(z);
        end;
        primes.Add(v);
        write(v:9);
        if c mod 10 = 0 then writeln;
        if c = cutOff then
        begin
          showEach := false;
          write('Progress to the ', bigUn, 'th cuban prime: ')
        end;
      end;
      if c mod little = 0 then
      begin
        write('.');
        if c = bigUn then break;
      end;
    end;
  end;
  writeln();
  writeln('The ', c, 'th cuban prime is ', v);
  writeln('Computation time was ', milliseconds / 1000, ' seconds');
end.

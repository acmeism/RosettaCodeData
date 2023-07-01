program long_year(input);
  var
    y: integer;

  function rd_dec31(year: integer): integer;
  begin
    { Rata Die of Dec 31, year }
    rd_dec31 := year * 365 + year div 4 - year div 100 + year div 400
  end;

  function rd_jan1(year: integer): integer;
  begin
    rd_jan1 := rd_dec31(year - 1) + 1
  end;

  function weekday(rd: integer): integer;
  begin
    weekday := rd mod 7;
  end;

  function long_year(year: integer): boolean;
  var
    jan1: integer;
    dec31: integer;
  begin
    jan1 := rd_jan1(year);
    dec31 := rd_dec31(year);
    long_year := (weekday(jan1) = 4) or (weekday(dec31) = 4)
  end;

  begin
    for y := 1990 to 2050 do
      if long_year(y) then
        writeln(y)
  end.

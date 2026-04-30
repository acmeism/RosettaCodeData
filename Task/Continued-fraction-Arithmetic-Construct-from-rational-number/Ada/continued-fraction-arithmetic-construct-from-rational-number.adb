with ada.text_io; use ada.text_io;
with ada.strings; use ada.strings;
with ada.strings.fixed; use ada.strings.fixed;

procedure continued_fraction_from_rational is

  -- The following implementation of r2cf both modifies its arguments
  -- and returns a value.
  function r2cf (N1 : in out integer;
                 N2 : in out integer)
    return integer
  is
    q, r : integer;
  begin
    -- We will use floor division, where the quotient is rounded
    -- towards negative infinity. Whenever the divisor is positive,
    -- this type of division gives a non-negative remainder.
    r := N1 mod N2;
    q := (N1 - r) / N2;

    N1 := N2;
    N2 := r;

    return q;
  end r2cf;

  procedure write_r2cf (N1 : in integer;
                        N2 : in integer)
  is
    M1, M2 : integer;
    digit : integer;
    sep : integer;
  begin
    put (trim (integer'image (N1), left));
    put ("/");
    put (trim (integer'image (N2), left));
    put (" => ");

    M1 := N1;
    M2 := N2;
    sep := 0;
    while M2 /= 0 loop
      digit := r2cf (M1, M2);
      if sep = 0 then
        put ("[");
        sep := 1;
      elsif sep = 1 then
        put ("; ");
        sep := 2;
      else
        put (", ");
      end if;
      put (trim (integer'image (digit), left));
    end loop;
    put_line ("]");
  end write_r2cf;

begin

  write_r2cf (1, 2);
  write_r2cf (3, 1);
  write_r2cf (23, 8);
  write_r2cf (13, 11);
  write_r2cf (22, 7);
  write_r2cf (-151, 77);

  write_r2cf (14142, 10000);
  write_r2cf (141421, 100000);
  write_r2cf (1414214, 1000000);
  write_r2cf (14142136, 10000000);

  write_r2cf (31, 10);
  write_r2cf (314, 100);
  write_r2cf (3142, 1000);
  write_r2cf (31428, 10000);
  write_r2cf (314285, 100000);
  write_r2cf (3142857, 1000000);
  write_r2cf (31428571, 10000000);
  write_r2cf (314285714, 100000000);

end continued_fraction_from_rational;

with ada.text_io; use ada.text_io;

procedure golden_ratio_convergence is

  -- This is a fixed-point type. I typed a bunch of "0"
  -- without counting them.
  type number is delta 0.000000000000001 range -10.0 .. 10.0;

  one : constant number := number (1.0);
  phi : constant number := number (1.61803398874989484820458683436563811772030917980576286213544862270526046281890244970720720418939113748475); -- OEIS A001622
  phi0, phi1 : number;
  count : integer;

begin
  count := 1;
  phi0 := 1.0;
  phi1 := (one + (one / phi0));
  while abs (phi1 - phi0) > number (1.0e-5) loop
    count := count + 1;
    phi0 := phi1;
    phi1 := (one + (one / phi0));
  end loop;
  put ("Result:");
  put (phi1'image);
  put (" after");
  put (count'image);
  put_line (" iterations");
  put ("The error is approximately ");
  put_line (number'image (phi1 - phi));
end golden_ratio_convergence;

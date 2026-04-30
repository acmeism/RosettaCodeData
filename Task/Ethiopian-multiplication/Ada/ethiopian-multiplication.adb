with ada.text_io;use ada.text_io;

procedure ethiopian is
  function double  (n : Natural) return Natural is (2*n);
  function halve   (n : Natural) return Natural is (n/2);
  function is_even (n : Natural) return Boolean is (n mod 2 = 0);

  function mul (l, r : Natural) return Natural is
  (if l = 0 then 0 elsif l = 1 then r elsif is_even (l) then mul (halve (l),double (r))
   else r + double (mul (halve (l), r)));

begin
  put_line (mul (17,34)'img);
end ethiopian;

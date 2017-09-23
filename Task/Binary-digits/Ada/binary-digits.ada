with ada.text_io;use ada.text_io;
procedure binary is
-- the digits in base 2
  bit : array (0..1) of string (1..1) := ("0","1");
-- the conversion function itself
  function bin_image (n : Natural) return string is (if n<2 then bit (n) else bin_image (n/2)&bit(n mod 2));
-- the values we want to test
  test_values : array (1..3) of Natural := (5,50,9000);
begin
  for test of test_values loop put_line ("Output for"&test'img&" is "&bin_image (test)); end loop;
end binary;

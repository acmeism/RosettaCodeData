wwith ada.text_io;use ada.text_io;
procedure binary is
  bit : array (0..1) of character := ('0','1');

  function bin_image (n : Natural) return string is
  (if n < 2 then (1 => bit (n)) else bin_image (n / 2) & bit (n mod 2));

  test_values : array (1..3) of Natural := (5,50,9000);
begin
  for test of test_values loop
	put_line ("Output for" & test'img & " is " & bin_image (test));
  end loop;
end binary;

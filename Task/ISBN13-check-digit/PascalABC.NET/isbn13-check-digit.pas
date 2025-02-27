##
function CheckISBN13(code: string): boolean;
begin
  result := false;
  code := code.Replace('-', '').Replace(' ', '');
  if (code.Length <> 13) then exit;
  var sum := 0;
  foreach var digit in code index i do
    if digit.isdigit then
      sum += digit.ToDigit * (if i mod 2 = 0 then 1 else 3)
    else exit;
  result := sum mod 10 = 0;
end;

CheckISBN13('978-0596528126').Println;
CheckISBN13('978-0596528120').Println;
CheckISBN13('978-1788399081').Println;
CheckISBN13('978-1788399083').Println;

uses System;

function URLDecode(s: string) := Uri.UnescapeDataString(s);

begin
  Println(URLDecode('http%3A%2F%2Ffoo%20bar%2F'));
  Println(URLDecode('google.com/search?q=%60Abdu%27l-Bah%C3%A1'));
  Println(URLDecode('%25%32%35'));
end.

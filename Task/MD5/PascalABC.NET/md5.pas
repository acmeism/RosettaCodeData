##
uses System.Security.Cryptography;

var data := Encoding.ASCII.GetBytes('The quick brown fox jumped over the lazy dog''s back');
foreach var h in MD5.Create().ComputeHash(data) do
  h.ToString('X2').print;

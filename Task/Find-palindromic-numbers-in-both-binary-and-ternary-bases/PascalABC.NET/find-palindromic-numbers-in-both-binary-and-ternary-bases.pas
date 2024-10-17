// https://rosettacode.org/wiki/Find_palindromic_numbers_in_both_binary_and_ternary_bases#Perl#PascalABC.NET

uses School;

function ToBase(n: int64; base: integer): string;
begin
  var sb := new StringBuilder;
  while n>0 do
  begin
    sb.Insert(0,n mod base);
    n := n div base;
  end;
  Result := sb.ToString;
end;

function IsPalindrome(s: string): boolean := s = s.Inverse;

begin
  Println(0,0,0);
  for var i: int64 := 0 to 1000000 do
  begin
    var d3 := ToBase(i,3);
    d3 := d3 + '1' + d3.Inverse;
    var d := Dec(d3,3);
    var d2 := ToBase(d,2);
    if IsPalindrome(d2) then
      Println(d,d3,d2)
  end;
end.

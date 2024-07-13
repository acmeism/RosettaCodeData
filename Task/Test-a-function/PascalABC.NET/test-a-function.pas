uses NUnitABC;

function IsPalindrome(s: string) := s = s[::-1];

[Test]
procedure Test1;
begin
  Assert.AreEqual(IsPalindrome('abba'),True);
  Assert.AreNotEqual(IsPalindrome('abcd'),True);
end;

begin
end.

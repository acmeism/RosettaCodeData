function IsPalindrome(s: string) := s = s[::-1];

begin
  Println(IsPalindrome('arozaupalanalapuazora'));
  Println(IsPalindrome('abcd'));
end.

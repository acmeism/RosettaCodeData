begin

comment
   The string concatenation operator is ||, and the
   default string length is 10 characters unless a
   longer length (up to 255) is explicitly declared;

string(20) s1, s2;

s1 := "Hello";
write (s1 || ", world");

s2 := s1 || ", world";
write (s2);

end

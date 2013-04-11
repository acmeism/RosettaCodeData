procedure test_r(s : String; r : Boolean);
begin
   write('"', s, '" is ');
   if ( not r ) then
      write('not ');
   writeln('palindrome')
end;

var
   s1, s2 : String;

begin
   s1 := 'ingirumimusnocteetconsumimurigni';
   s2 := 'in girum imus nocte';
   test_r(s1, is_palindro_r(s1));
   test_r(s2, is_palindro_r(s2));
   test_r(s1, is_palindro(s1));
   test_r(s2, is_palindro(s2))
end.

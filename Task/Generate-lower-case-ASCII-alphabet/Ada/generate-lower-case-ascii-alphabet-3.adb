   B : Arr_Type (1 .. 26);
begin
   B(B'First) := 'a';
   for I in B'First .. B'Last-1 loop
      B(I+1) := Lower_Case'Succ(B(I));
   end loop; -- now all the B(I) are different

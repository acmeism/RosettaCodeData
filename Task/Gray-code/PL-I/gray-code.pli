(stringrange, stringsize):
Gray_code: procedure options (main);  /* 15 November 2013 */
   declare (bin(0:31), g(0:31), b2(0:31)) bit (5);
   declare (c, carry) bit (1);
   declare (i, j) fixed binary (7);

   bin(0) = '00000'b;
   do i = 0 to 31;
      if i > 0 then
         do;
            carry = '1'b;
            bin(i) = bin(i-1);
            do j = 5 to 1 by -1;
               c = substr(bin(i), j, 1) & carry;
               substr(bin(i), j, 1) = substr(bin(i), j, 1) ^ carry;
               carry = c;
            end;
         end;
      g(i) = bin(i) ^ '0'b || substr(bin(i), 1, 4);
   end;
   do i = 0 to 31;
      substr(b2(i), 1, 1) = substr(g(i), 1, 1);
      do j = 2 to 5;
         substr(b2(i), j, 1) = substr(g(i), j, 1) ^ substr(bin(i), j-1, 1);
      end;
   end;

   do i = 0 to 31;
      put skip edit (i, bin(i), g(i), b2(i)) (f(2), 3(x(1), b));
   end;
end Gray_code;

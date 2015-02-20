with Prime_Numbers, Ada.Text_IO;

procedure Test_Kth_Prime is

   package Integer_Numbers is new
     Prime_Numbers (Natural, 0, 1, 2);
   use Integer_Numbers;

   Out_Length: constant Positive := 10; -- 10 k-th almost primes
   N: Positive; -- the "current number" to be checked

begin
   for K in 1 .. 5 loop
      Ada.Text_IO.Put("K =" & Integer'Image(K) &":  ");
      N := 2;
      for I in 1 .. Out_Length loop
	 while Decompose(N)'Length /= K loop
	    N := N + 1;
	 end loop; -- now N is Kth almost prime;
	 Ada.Text_IO.Put(Integer'Image(Integer(N)));
	 N := N + 1;
      end loop;
      Ada.Text_IO.New_Line;
   end loop;
end Test_Kth_Prime;

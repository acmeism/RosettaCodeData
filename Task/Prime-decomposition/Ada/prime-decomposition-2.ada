package body Prime_Numbers is
   function Decompose (N : Number) return Number_List is
      Size : Natural := 0;
      M    : Number  := N;
      K    : Number  := Two;
   begin
      -- Estimation of the result length from above
      while M >= Two loop
	 M := (M + One) / Two;
	 Size := Size + 1;
      end loop;
      M := N;
      -- Filling the result with prime numbers
      declare
	 Result : Number_List (1..Size);
	 Index  : Positive := 1;
      begin
	 while N >= K loop -- Divisors loop
	    while Zero = (M mod K) loop -- While divides
	       Result (Index) := K;
	       Index := Index + 1;
	       M := M / K;
	    end loop;
	    K := K + One;
	 end loop;
	 return Result (1..Index - 1);
      end;
   end Decompose;

end Prime_Numbers;

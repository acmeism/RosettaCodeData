with Ada.Text_IO, Miller_Rabin;

procedure Prime_Gen is

   type Num is range 0 .. 2**63-1; -- maximum for the gnat Ada compiler

   MR_Iterations: constant Positive := 25;
     -- the probability Pr[Is_Prime(N, MR_Iterations) = Probably_Prime]
     -- is 1 for prime N and < 4**(-MR_Iterations) for composed N

   function Next(P: Num) return Num is
      N: Num := P+1;
      package MR is new Miller_Rabin(Num); use MR;
   begin
      while not (Is_Prime(N, MR_Iterations) = Probably_Prime) loop
	 N := N + 1;
      end loop;
      return N;
   end Next;

   Current: Num;
   Count: Num := 0;

begin
   -- show the first twenty primes
   Ada.Text_IO.Put("First 20 primes:");
   Current := 1;
   for I in 1 .. 20 loop
      Current := Next(Current);
      Ada.Text_IO.Put(Num'Image(Current));
   end loop;
   Ada.Text_IO.New_Line;

   -- show the primes between 100 and 150
   Ada.Text_IO.Put("Primes between 100 and 150:");
   Current := 99;
   loop
      Current := Next(Current);
      exit when Current > 150;
      Ada.Text_IO.Put(Num'Image(Current));
   end loop;
   Ada.Text_IO.New_Line;

   -- count primes between 7700 and 8000
   Ada.Text_IO.Put("Number of primes between 7700 and 8000:");
   Current := 7699;
   loop
      Current := Next(Current);
      exit when Current > 8000;
      Count := Count + 1;
   end loop;
   Ada.Text_IO.Put_Line(Num'Image(Count));

   Count := 10;
   Ada.Text_IO.Put_Line("Print the K_i'th prime, for $K=10**i:");
   begin
      loop
	 Current := 1;
	 for I in 1 .. Count loop
	    Current := Next(Current);
	 end loop;
	 Ada.Text_IO.Put(Num'Image(Count) & "th prime:" &
			Num'Image(Current));
	 Count := Count * 10;
      end loop;
   exception
      when Constraint_Error =>
	 Ada.Text_IO.Put_Line(" can't compute the" & Num'Image(Count) &
				"th prime:");
   end;
end;

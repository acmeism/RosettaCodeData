with Ada.Text_IO, Miller_Rabin;

procedure Emirp_Gen is

   type Num is range 0 .. 2**63-1; -- maximum for the gnat Ada compiler

   MR_Iterations: constant Positive := 25;
     -- the probability Pr[Is_Prime(N, MR_Iterations) = Probably_Prime]
     -- is 1 for prime N and < 4**(-MR_Iterations) for composed N

   function Is_Emirp(E: Num) return Boolean is
      package MR is new Miller_Rabin(Num); use MR;

      function Rev(E: Num) return Num is
	 N: Num := E;
	 R: Num := 0;
      begin
	 while N > 0 loop
	    R := 10*R + N mod 10; -- N mod 10 is least significant digit of N
	    N := N / 10;          -- delete least significant digit of N
	 end loop;
	 return R;
      end Rev;

      R: Num := Rev(E);
   begin
      return E /= R and then
	     (Is_Prime(E, MR_Iterations) = Probably_Prime) and then
	     (Is_Prime(R, MR_Iterations) = Probably_Prime);
   end Is_Emirp;
	
   function Next(P: Num) return Num is
      N: Num := P+1;
   begin
      while not (Is_Emirp(N)) Loop
	 N := N + 1;
      end loop;
      return N;
   end Next;

   Current: Num;
   Count: Num := 0;

begin
   -- show the first twenty emirps
   Ada.Text_IO.Put("First 20 emirps:");
   Current := 1;
   for I in 1 .. 20 loop
      Current := Next(Current);
      Ada.Text_IO.Put(Num'Image(Current));
   end loop;
   Ada.Text_IO.New_Line;

   -- show the emirps between 7700 and 8000
   Ada.Text_IO.Put("Emirps between 7700 and 8000:");
   Current := 7699;
   loop
      Current := Next(Current);
      exit when Current > 8000;
       Ada.Text_IO.Put(Num'Image(Current));
   end loop;

   -- the 10_000th emirp
   Ada.Text_IO.Put("The 10_000'th emirp:");
   for I in 1 .. 10_000 loop
      Current := Next(Current);
   end loop;
   Ada.Text_IO.Put_Line(Num'Image(Current));
end Emirp_Gen;

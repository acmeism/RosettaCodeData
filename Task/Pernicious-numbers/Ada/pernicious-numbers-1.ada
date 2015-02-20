with Ada.Text_IO, Population_Count; use Population_Count;

procedure Pernicious is

   Prime: array(0 .. 64) of Boolean;
     -- we are using 64-bit numbers, so the population count is between 0 and 64
   X: Num; use type Num;
   Cnt: Positive;
begin
   -- initialize array Prime; Prime(I) must be true if and only if I is a prime
   Prime := (0 => False, 1 => False, others => True);
   for I in 2 .. 8 loop
      if Prime(I) then
	 Cnt := I + I;
	 while Cnt <= 64 loop
	    Prime(Cnt) := False;
	    Cnt := Cnt + I;
	 end loop;
      end if;
   end loop;

   -- print first 25 pernicious numbers
   X := 1;
   for I in 1 .. 25 loop
      while not Prime(Pop_Count(X)) loop
	 X := X + 1;
      end loop;
      Ada.Text_IO.Put(Num'Image(X));
      X := X + 1;
   end loop;
   Ada.Text_IO.New_Line;

   -- print pernicious numbers between  888_888_877 and 888_888_888 (inclusive)
   for Y in Num(888_888_877) .. 888_888_888 loop
      if Prime(Pop_Count(Y)) then
	 Ada.Text_IO.Put(Num'Image(Y));
      end if;
   end loop;
   Ada.Text_IO.New_Line;
end;

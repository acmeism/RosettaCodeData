   Counter: Natural;
begin
   -- initialize array Prime; Prime(I) must be true if and only if I is a prime
   ...

   Counter := 0;
   -- count p. numbers below 2**32
   for Y in Num(2) .. 2**32 loop
      if Prime(Pop_Count(Y)) then
	 Counter := Counter + 1;
      end if;
   end loop;
   Ada.Text_IO.Put_Line(Natural'Image(Counter));
end Count_Pernicious;

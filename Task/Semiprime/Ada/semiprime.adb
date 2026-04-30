with Prime_Numbers, Ada.Text_IO;

procedure Test_Semiprime is

   package Integer_Numbers is new
     Prime_Numbers (Natural, 0, 1, 2);
   use Integer_Numbers;

begin
   for N in 1 .. 100 loop
      if Decompose(N)'Length = 2 then -- N is a semiprime;
	 Ada.Text_IO.Put(Integer'Image(Integer(N)));
      end if;
   end loop;
   Ada.Text_IO.New_Line;
   for N in 1675 .. 1680 loop
      if Decompose(N)'Length = 2 then -- N is a semiprime;
	 Ada.Text_IO.Put(Integer'Image(Integer(N)));
      end if;
   end loop;
end Test_Semiprime;

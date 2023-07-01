with Ada.Text_IO;

procedure Narcissistic is

   function Is_Narcissistic(N: Natural) return Boolean is
      Decimals: Natural := 1;
      M: Natural := N;
      Sum: Natural := 0;
   begin
      while M >= 10 loop
	 M := M / 10;
	 Decimals := Decimals + 1;
      end loop;
      M := N;
      while M >= 1 loop
	 Sum := Sum + (M mod 10) ** Decimals;
	 M := M/10;
      end loop;
      return Sum=N;
   end Is_Narcissistic;

   Count, Current: Natural := 0;

begin
   while Count < 25 loop
      if Is_Narcissistic(Current) then
	 Ada.Text_IO.Put(Integer'Image(Current));
	 Count := Count + 1;
      end if;
      Current := Current + 1;
   end loop;
end Narcissistic;

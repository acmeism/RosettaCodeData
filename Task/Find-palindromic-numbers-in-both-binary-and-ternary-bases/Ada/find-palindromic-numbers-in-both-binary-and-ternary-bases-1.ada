with Ada.Text_IO, Base_Conversion;

procedure Brute is

   type Long is range 0 .. 2**63-1;
   package BC is new Base_Conversion(Long);

   function Palindrome (S : String) return Boolean is
      (if S'Length < 2 then True
      elsif S(S'First) /= S(S'Last) then False
      else Palindrome(S(S'First+1 .. S'Last-1)));

   function Palindrome(N: Long; Base: Natural) return Boolean is
      (Palindrome(BC.Image(N, Base =>Base)));
	
  package IIO is new Ada.Text_IO.Integer_IO(Long);

begin
   for I in Long(1) .. 10**8 loop
      if Palindrome(I, 3) and then Palindrome(I, 2) then
	 IIO.Put(I, Width => 12); -- prints I (Base 10)
	 Ada.Text_IO.Put_Line(": " & BC.Image(I, Base => 2) & "(2)" &
			      ", " & BC.Image(I, Base => 3) & "(3)");
	 -- prints I (Base 2 and Base 3)
      end if;
      end loop;
end Brute;

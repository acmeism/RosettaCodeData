with Ada.Text_IO;

procedure Test_Function is

   function Palindrome (Text : String) return Boolean is
   begin
      for Offset in 0 .. Text'Length / 2 - 1 loop
         if Text (Text'First + Offset) /= Text (Text'Last - Offset) then
            return False;
         end if;
      end loop;
      return True;
   end Palindrome;

   str1 : String := "racecar";
   str2 : String := "wombat";

begin
   begin
      pragma Assert(False); -- raises an exception if assertions are switched on
      Ada.Text_IO.Put_Line("Skipping the test! Please compile with assertions switched on!");
   exception
      when others => -- assertions are switched on -- perform the tests
         pragma Assert (Palindrome (str1) = True,  "Assertion on str1 failed");
         pragma Assert (Palindrome (str2) = False, "Assertion on str2 failed");
         Ada.Text_IO.Put_Line("Test Passed!");
   end;
end Test_Function;

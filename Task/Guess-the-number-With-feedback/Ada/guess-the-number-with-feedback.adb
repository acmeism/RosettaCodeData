with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
procedure Guess_Number_Feedback is
   function Get_Int (Prompt : in String) return Integer is
   begin
      loop
         Ada.Text_IO.Put (Prompt);
         declare
            Response : constant String := Ada.Text_IO.Get_Line;
         begin
            if Response /= "" then
               return Integer'Value (Response);
            end if;
         exception
            when others =>
               Ada.Text_IO.Put_Line ("Invalid response, not an integer!");
         end;
      end loop;
   end Get_Int;
   procedure Guess_Number (Lower_Limit : Integer; Upper_Limit : Integer) is
      subtype Number is Integer range Lower_Limit .. Upper_Limit;
      package Number_RNG is new Ada.Numerics.Discrete_Random (Number);
      Generator  : Number_RNG.Generator;
      My_Number  : Number;
      Your_Guess : Integer;
   begin
      Number_RNG.Reset (Generator);
      My_Number := Number_RNG.Random (Generator);
      Ada.Text_IO.Put_Line ("Guess my number!");
      loop
         Your_Guess := Get_Int ("Your guess: ");
         exit when Your_Guess = My_Number;
         if Your_Guess > My_Number then
            Ada.Text_IO.Put_Line ("Wrong, too high!");
         else
            Ada.Text_IO.Put_Line ("Wrong, too low!");
         end if;
      end loop;
      Ada.Text_IO.Put_Line ("Well guessed!");
   end Guess_Number;
   Lower_Limit : Integer;
   Upper_Limit : Integer;
begin
   loop
      Lower_Limit := Get_Int  ("Lower Limit: ");
      Upper_Limit := Get_Int  ("Upper Limit: ");
      exit when Lower_Limit < Upper_Limit;
      Ada.Text_IO.Put_Line ("Lower limit must be lower!");
   end loop;
   Guess_Number (Lower_Limit, Upper_Limit);
end Guess_Number_Feedback;

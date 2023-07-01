with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
procedure Test_All_Chars_Are_Same is
   procedure All_Chars_Are_Same (S : in String) is
      First_Diff : Natural := 0;
   begin
      Put_Line ("Input = """ & S & """, length =" & S'Length'Image);
      for I in S'First + 1 .. S'Last loop
         if S(I) /= S(S'First) then
            First_Diff := I;
            exit;
         end if;
      end loop;
      if First_Diff = 0 then
         Put_Line (" All characters are the same.");
      else
         Put (" First difference at position" & First_Diff'Image &
              ", character = '" & S(First_Diff) &
              "', hex = ");
         Put (Character'Pos (S(First_Diff)), Width => 0, Base => 16);
         New_Line;
      end if;
   end All_Chars_Are_Same;
begin
   All_Chars_Are_Same ("");
   All_Chars_Are_Same ("   ");
   All_Chars_Are_Same ("2");
   All_Chars_Are_Same ("333");
   All_Chars_Are_Same (".55");
   All_Chars_Are_Same ("tttTTT");
   All_Chars_Are_Same ("4444 444k");
end Test_All_Chars_Are_Same;

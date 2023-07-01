with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
procedure Test_All_Chars_Unique is
   procedure All_Chars_Unique (S : in String) is
   begin
      Put_Line ("Input = """ & S & """, length =" & S'Length'Image);
      for I in S'First .. S'Last - 1 loop
         for J in I + 1 .. S'Last loop
            if S(I) = S(J) then
               Put (" First duplicate at positions" & I'Image &
                    " and" & J'Image & ", character = '" & S(I) &
                    "', hex = ");
               Put (Character'Pos (S(I)), Width => 0, Base => 16);
               New_Line;
               return;
            end if;
         end loop;
      end loop;
      Put_Line (" All characters are unique.");
   end All_Chars_Unique;
begin
   All_Chars_Unique ("");
   All_Chars_Unique (".");
   All_Chars_Unique ("abcABC");
   All_Chars_Unique ("XYZ ZYX");
   All_Chars_Unique ("1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ");
end Test_All_Chars_Unique;

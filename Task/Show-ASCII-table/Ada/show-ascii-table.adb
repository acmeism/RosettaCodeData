with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Ascii_Table is
   N : Integer;
begin
   for R in 0 .. 15 loop
      for C in 0 .. 5 loop
         N := 32 + 16 * C + R;
         Put (N, 3);
         Put (" : ");
         case N is
            when 32 =>
               Put ("Spc  ");
            when 127 =>
               Put ("Del  ");
            when others =>
               Put (Character'Val (N) & "    ");
         end case;
      end loop;
      New_Line;
   end loop;
end Ascii_Table;

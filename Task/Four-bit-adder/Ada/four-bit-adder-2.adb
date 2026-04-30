with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_4_Bit_Adder is

   -- The definitions from above

   function Image (Bit : Boolean) return Character is
   begin
      if Bit then
         return '1';
      else
         return '0';
      end if;
   end Image;

   function Image (X : Four_Bits) return String is
   begin
      return Image (X (1)) & Image (X (2)) & Image (X (3)) & Image (X (4));
   end Image;

   A, B, C : Four_Bits; Carry : Boolean;
begin
   for I_1 in Boolean'Range loop
      for I_2 in Boolean'Range loop
         for I_3 in Boolean'Range loop
            for I_4 in Boolean'Range loop
               for J_1 in Boolean'Range loop
                  for J_2 in Boolean'Range loop
                     for J_3 in Boolean'Range loop
                        for J_4 in Boolean'Range loop
                           A := (I_1, I_2, I_3, I_4);
                           B := (J_1, J_2, J_3, J_4);
                           Carry := False;
                           Four_Bits_Adder (A, B, C, Carry);
                           Put_Line
                           (  Image (A)
                           &  " + "
                           &  Image (B)
                           &  " = "
                           &  Image (C)
                           &  " "
                           &  Image (Carry)
                           );
                        end loop;
                     end loop;
                  end loop;
               end loop;
            end loop;
         end loop;
      end loop;
   end loop;
end Test_4_Bit_Adder;

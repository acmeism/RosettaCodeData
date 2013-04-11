with Ada.Text_IO;

procedure Decode_Roman_Numerals is

   function Roman_To_Integer(A_Roman: String) return Integer is

      function Decode_Roman_Digit (A_Char: Character) return Integer is
      begin
         case A_Char is
            when 'M' | 'm' => return 1000;
            when 'D' | 'd' => return 500;
            when 'C' | 'c' => return 100;
            when 'L' | 'l' => return 50;
            when 'X' | 'x' => return 10;
            when 'V' | 'v' => return 5;
            when 'I' | 'i' => return  1;
            when others => return 0;
         end case;
      end Decode_Roman_Digit;

      L_Curr_Val: Integer;
      L_Last_Val: Integer;

      Result: Integer;
   begin
      Result := 0;

      L_Last_Val := 0;

      for i in reverse 1 .. A_Roman'Length loop
         L_Curr_Val := Decode_Roman_Digit(A_Roman(I));
         if L_Curr_Val < L_Last_Val then
            Result := Result - L_Curr_Val;
         else
            Result := Result + L_Curr_Val;
         end if;
         L_Last_Val := L_Curr_Val;
      end loop;
      return Result;
   end Roman_To_Integer;

begin
   Ada.Text_IO.Put_Line(Integer'Image(Roman_To_Integer("MCMXC")));    -- 1990
   Ada.Text_IO.Put_Line(Integer'Image(Roman_To_Integer("MMVIII")));   -- 2008
   Ada.Text_IO.Put_Line(Integer'Image(Roman_To_Integer("MDCLXVI")));  -- 1666
end Decode_Roman_Numerals;

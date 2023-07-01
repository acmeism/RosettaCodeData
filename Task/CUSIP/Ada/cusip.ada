with Ada.Text_IO;

procedure Cusip_Test is
   use Ada.Text_IO;

   subtype Cusip is String (1 .. 9);

   function Check_Cusip (Code : Cusip) return Boolean is
      Sum : Integer := 0;
      V   : Integer;

   begin
      for I in Code'First .. Code'Last - 1 loop
         case Code (I) is
            when '0' .. '9' =>
               V := Character'Pos (Code (I)) - Character'Pos ('0');
            when 'A' .. 'Z' =>
               V := Character'Pos (Code (I)) - Character'Pos ('A') + 10;
            when '*' => V := 36;
            when '@' => V := 37;
            when '#' => V := 38;
            when others => return False;
         end case;

         if I mod 2 = 0 then
            V := V * 2;
         end if;

         Sum := Sum + V / 10 + (V mod 10);
      end loop;

      return (10 - (Sum mod 10)) mod 10 =
        Character'Pos (Code (Code'Last)) - Character'Pos ('0');
   end Check_Cusip;

   type Cusip_Array is array (Natural range <>) of Cusip;

   Test_Array : Cusip_Array :=
     ("037833100",
      "17275R102",
      "38259P508",
      "594918104",
      "68389X106",
      "68389X105");
begin
   for I in Test_Array'Range loop
      Put (Test_Array (I) & ": ");
      if Check_Cusip (Test_Array (I)) then
         Put_Line ("valid");
      else
         Put_Line ("not valid");
      end if;
   end loop;
end Cusip_Test;

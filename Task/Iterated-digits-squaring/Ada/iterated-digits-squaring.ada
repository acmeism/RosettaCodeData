with Ada.Text_IO;

procedure Digits_Squaring is

   function Is_89 (Number : in Positive) return Boolean
   is
      Squares : constant array (0 .. 9)  of Natural :=
        (0, 1, 4, 9, 16, 25, 36, 49, 64, 81);

      Sum : Natural := Number;
      Acc : Natural;
   begin
      loop
         Acc := Sum;
         Sum := 0;
         while Acc > 0 loop
            Sum := Sum + Squares (Acc mod 10);
            Acc := Acc / 10;
         end loop;

         if Sum = 89 then  return True;  end if;
         if Sum =  1 then  return False; end if;
      end loop;
   end Is_89;

   use Ada.Text_IO;
   Count : Natural := 0;
begin
   for A in 1 .. 99_999_999 loop
      if Is_89 (A) then
         Count := Count + 1;
      end if;

      if A = 999_999 then
         Put_Line ("In range 1 ..    999_999: " & Count'Image);
      end if;

   end loop;
   Put_Line ("In range 1 .. 99_999_999: " & Count'Image);
end Digits_Squaring;

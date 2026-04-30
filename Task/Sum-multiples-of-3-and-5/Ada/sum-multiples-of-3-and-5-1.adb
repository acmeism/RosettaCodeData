with Ada.Text_IO;

procedure Sum_Multiples is

   type Natural is range 0 .. 2**63 - 1;

   function Sum_3_5 (Limit : in Natural) return Natural is
      Sum : Natural := 0;
   begin
      for N in 1 .. Limit - 1 loop
         if N mod 3 = 0 or else N mod 5 = 0 then
            Sum := Sum + N;
         end if;
      end loop;
      return Sum;
   end Sum_3_5;

begin
   Ada.Text_IO.Put_Line ("n=1000: " & Sum_3_5 (1000)'Image);
   Ada.Text_IO.Put_Line ("n=5e9 : " & Sum_3_5 (5e9)'Image);
end Sum_Multiples;

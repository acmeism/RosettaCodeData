with Ada.Text_IO;

procedure Jewels_And_Stones is

   function Count (Jewels, Stones : in String) return Natural is
      Sum : Natural := 0;
   begin
      for J of Jewels loop
         for S of Stones loop
            if J = S then
               Sum := Sum + 1;
               exit;
            end if;
         end loop;
      end loop;
      return Sum;
   end Count;

   procedure Show (Jewels, Stones : in String) is
      use Ada.Text_IO;
   begin
      Put (Jewels);
      Set_Col (12); Put (Stones);
      Set_Col (20); Put (Count (Jewels => Jewels,
                                Stones => Stones)'Image);
      New_Line;
   end Show;

begin
   Show ("aAAbbbb", "aA");
   Show ("ZZ",      "z");
end Jewels_And_Stones;

package body Shell_Sort is

   ----------
   -- Sort --
   ----------

   procedure Sort (Item : in out Array_Type) is
      Increment : Natural := Index_Type'Pos(Item'Last) / 2;
      J : Index_Type;
      Temp : Element_Type;
   begin
      while Increment > 0 loop
         for I in Index_Type'Val(Increment) .. Item'Last loop
            J := I;
            Temp := Item(I);
            while J > Index_Type'val(Increment) and then Item (Index_Type'Val(Index_Type'Pos(J) - Increment)) > Temp loop
               Item(J) := Item (Index_Type'Val(Index_Type'Pos(J) - Increment));
               J := Index_Type'Val(Index_Type'Pos(J) - Increment);
            end loop;
            Item(J) := Temp;
         end loop;
         if Increment = 2 then
            Increment := 1;
         else
            Increment := Increment * 5 / 11;
         end if;
      end loop;
   end Sort;

end Shell_Sort;

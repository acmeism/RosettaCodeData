-----------------------------------------------------------------------
-- Generic Quicksort procedure
-----------------------------------------------------------------------

procedure Sort (Item : in out Element_Array) is

   procedure Swap(Left, Right : in out Element_Type) is
      Temp : Element_Type := Left;
   begin
      Left := Right;
      Right := Temp;
   end Swap;

   Pivot_Index : Index_Type;
   Pivot_Value : Element_Type;
   Right       : Index_Type := Item'Last;
   Left        : Index_Type := Item'First;

begin
   if Item'Length > 1 then
      Pivot_Index := Index_Type'Val((Index_Type'Pos(Item'Last) + 1 +
                                    Index_Type'Pos(Item'First)) / 2);
      Pivot_Value := Item(Pivot_Index);

      Left  := Item'First;
      Right := Item'Last;
      loop
         while Left < Item'Last and then Item(Left) < Pivot_Value loop
            Left := Index_Type'Succ(Left);
         end loop;
         while Right > Item'First and then Item(Right) > Pivot_Value loop
            Right := Index_Type'Pred(Right);
         end loop;
         exit when Left >= Right;
         Swap(Item(Left), Item(Right));
         if Pivot_Index = Left then
             Pivot_Index := Right;
         elsif Pivot_Index = Right then
             Pivot_Index := Left;
         end if;
      end loop;
      if Right > Item'First then
         Sort(Item(Item'First..Index_Type'Pred(Right)));
      end if;
      if Left < Item'Last then
         Sort(Item(Left..Item'Last));
      end if;
   end if;
end Sort;

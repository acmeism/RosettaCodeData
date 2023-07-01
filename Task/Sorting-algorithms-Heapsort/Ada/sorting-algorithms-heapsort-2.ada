procedure Generic_Heapsort(Item : in out Collection) is
   procedure Swap(Left : in out Element_Type; Right : in out Element_Type) is
      Temp : Element_Type := Left;
   begin
      Left := Right;
      Right := Temp;
   end Swap;
   procedure Sift_Down(Item : in out Collection) is
      Root : Integer := Index_Type'Pos(Item'First);
      Child : Integer := Index_Type'Pos(Item'Last);
      Last : Integer := Index_Type'Pos(Item'Last);
   begin
      while Root * 2 + 1 <= Last loop
         Child := Root * 2 + 1;
         if Child + 1 <= Last and then Item(index_Type'Val(Child)) < Item(Index_Type'Val(Child + 1)) then
            Child := Child + 1;
         end if;
         if Item(Index_Type'Val(Root)) < Item(Index_Type'Val(Child)) then
            Swap(Item(Index_Type'Val(Root)), Item(Index_Type'Val(Child)));
            Root := Child;
         else
            exit;
         end if;
      end loop;
   end Sift_Down;

   procedure Heapify(Item : in out Collection) is
      First_Pos : Integer := Index_Type'Pos(Index_Type'First);
      Last_Pos  : Integer := Index_Type'Pos(Index_type'Last);
      Start : Index_type := Index_Type'Val((Last_Pos - First_Pos + 1) / 2);
   begin
      loop
         Sift_Down(Item(Start..Item'Last));
         if Start > Index_Type'First then
            Start := Index_Type'Pred(Start);
         else
            exit;
         end if;
      end loop;
   end Heapify;
   Last_Index : Index_Type := Index_Type'Last;
begin
   Heapify(Item);
   while Last_Index > Index_Type'First loop
      Swap(Item(Last_Index), Item(Item'First));
      Last_Index := Index_Type'Pred(Last_Index);
      Sift_Down(Item(Item'First..Last_Index));
   end loop;

end Generic_Heapsort;

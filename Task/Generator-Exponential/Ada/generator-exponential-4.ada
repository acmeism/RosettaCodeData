package body Generator.Filtered is

   -----------
   -- Reset --
   -----------

   procedure Reset (Gen : in out Filtered_Generator) is
   begin
      Reset (Generator (Gen));
      Gen.Source.Reset;
      Gen.Filter.Reset;
      Gen.Last_Filter := 0;
   end Reset;

   --------------
   -- Get_Next --
   --------------

   function Get_Next (Gen : access Filtered_Generator) return Natural is
      Next_Source : Natural := Gen.Source.Get_Next;
      Next_Filter : Natural := Gen.Last_Filter;
   begin
      loop
         if Next_Source > Next_Filter then
            Gen.Last_Filter := Gen.Filter.Get_Next;
            Next_Filter := Gen.Last_Filter;
         elsif Next_Source = Next_Filter then
            Next_Source := Gen.Source.Get_Next;
         else
            return Next_Source;
         end if;
      end loop;
   end Get_Next;

   ----------------
   -- Set_Source --
   ----------------

   procedure Set_Source
     (Gen    : in out Filtered_Generator;
      Source : access Generator)
   is
   begin
      Gen.Source := Source;
   end Set_Source;

   ----------------
   -- Set_Filter --
   ----------------

   procedure Set_Filter
     (Gen    : in out Filtered_Generator;
      Filter : access Generator)
   is
   begin
      Gen.Filter := Filter;
   end Set_Filter;

end Generator.Filtered;

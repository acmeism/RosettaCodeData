package body Set_Of_Names is

   use type Ada.Containers.Count_Type, Vecs.Cursor;

   function Start(Names: Set) return Index_Type is
   begin
      if Names.Length = 0 then
         return 1;
      else
         return Names.First_Index;
      end if;
   end Start;

   function Stop(Names: Set) return Index_Type_With_Null is
   begin
      if Names.Length=0 then
         return 0;
      else
         return Names.Last_Index;
      end if;
   end Stop;

   function Size(Names: Set) return Index_Type_With_Null is
   begin
      return Index_Type_With_Null(Names.Length);
   end Size;

   procedure Add(Names: in out Set; Name: String; Index: out Index_Type) is
      I: Index_Type_With_Null := Names.Idx(Name);
   begin
      if I = 0 then -- Name is not yet in Set
         Names.Append(Name);
         Index := Names.Stop;
      else
        Index := I;
      end if;
   end Add;

   procedure Add(Names: in out Set; Name: String) is
      I: Index_Type;
   begin
      Names.Add(Name, I);
   end Add;

   procedure Sub(Names: in out Set; Name: String) is
      I: Index_Type_With_Null := Names.Idx(Name);
   begin
      if I /= 0 then -- Name is in set
         Names.Delete(I);
      end if;
   end Sub;

   function Idx(Names: Set; Name: String) return Index_Type_With_Null is
   begin
      for I in Names.First_Index .. Names.Last_Index loop
         if Names.Element(I) = Name then
            return I;
         end if;
      end loop;
      return 0;
   end Idx;

   function Name(Names: Set; Index: Index_Type) return String is
   begin
      return Names.Element(Index);
   end Name;

end Set_Of_Names;

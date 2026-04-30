package body Generic_Inverted_Index is

   use Source_Vecs;
   use type Maps.Cursor;


   procedure Store(Storage: in out Storage_Type;
                   Source: Source_Type;
                   Item: Item_Type) is
   begin
      if (Storage.Find(Item) = Maps.No_Element) then
         Storage.Insert(Key => Item,
                        New_Item => Empty_Vector & Source);
      else
         declare
            The_Vector: Vector := Storage.Element(Item);
         begin
            if The_Vector.Last_Element /= Source then
               Storage.Replace
                 (Key      => Item,
                  New_Item => Storage.Element(Item) & Source);
            end if;
         end;
      end if;
   end Store;

   function Find(Storage: Storage_Type; Item: Item_Type)
                return Vector is
   begin
      return Storage.Element(Item);
   exception
      when Constraint_Error => return Empty_Vector; -- found nothing
   end Find;

   function Is_In(S: Source_Type; V: Vector) return Boolean is
      VV: Vector := V;
   begin
      if Empty(V) then
         return False;
      elsif First_Source(V) = S then
         return True;
      else
         Delete_First_Source(VV);
         return Is_In(S, VV);
      end if;
   end Is_In;

   function "and"(Left, Right: Vector) return Vector is
       V: Vector := Empty_Vector;
   begin
      for I in First_Index(Left) .. Last_Index(Left) loop
         if Is_In(Element(Left, I), Right) then
            V := V & Element(Left, I);
         end if;
      end loop;
      return V;
   end "and";

   function "or"(Left, Right: Vector) return Vector is
       V: Vector := Left; -- all sources in Left
   begin -- ... add all sources in Right, which are not already in Left
      for I in First_Index(Right) .. Last_Index(Right) loop
         if not Is_In(Element(Right, I), Left) then
            V := V & Element(Right, I);
         end if;
      end loop;
      return V;
   end "or";

   function Empty(Vec: Vector) return Boolean
     renames Is_Empty;

   function First_Source(The_Sources: Vector)
                        return Source_Type renames First_Element;

   procedure Delete_First_Source(The_Sources: in out Vector;
                                 Count: Ada.Containers.Count_Type := 1)
     renames Delete_First;

   procedure Iterate(The_Sources: Vector) is
      V: Vector := The_Sources;
   begin
      while not Empty(V) loop
         Do_Something(First_Source(V));
         Delete_First_Source(V);
      end loop;
   end Iterate;

   function Same_Vector(U,V: Vector) return Boolean is
   begin
      raise Program_Error with "there is no need to call this function";
      return False; -- this avoices a compiler warning
   end Same_Vector;

end Generic_Inverted_Index;

package body Generic_Inverted_Index is
             -- uses some of the new Ada 2012 syntax
   use Source_Vecs;

   procedure Store(Storage: in out Storage_Type;
                   Source: Source_Type;
                   Item: Item_Type) is
      use type Maps.Cursor;
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
   begin
      for Some_Element of V loop
         if Some_Element = S then
            return True;
         end if;
      end loop;
      return False;
   end Is_In;

   function "and"(Left, Right: Vector) return Vector is
       V: Vector := Empty_Vector;
   begin
      for Some_Element of Left loop
         if Is_In(Some_Element, Right) then
            V := V & Some_Element;
         end if;
      end loop;
      return V;
   end "and";

   function "or"(Left, Right: Vector) return Vector is
       V: Vector := Left; -- all sources in Left
   begin
      for Some_Element of Right loop
         if not Is_In(Some_Element, Left) then
            V := V & Some_Element;
         end if;
      end loop;
      return V;
   end "or";

   function Empty(Vec: Vector) return Boolean
     renames Is_Empty;

   procedure Iterate(The_Sources: Vector) is
   begin
      for Some_Element in The_Sources loop
         Do_Something(Element(Some_Element));
      end loop;
   end Iterate;

   function Same_Vector(U,V: Vector) return Boolean is
   begin
      raise Program_Error with "there is no need to call this function";
      return False; -- this avoices a compiler warning
   end Same_Vector;

end Generic_Inverted_Index;

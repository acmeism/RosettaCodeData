with Ada.Containers.Indefinite_Vectors;

package body Mode is

   -- map Count to Elements
   package Count_Vectors is new Ada.Containers.Indefinite_Vectors
     (Element_Type => Element_Array,
      Index_Type => Positive);

   procedure Add (To : in out Count_Vectors.Vector; Item : Element_Type) is
      use type Count_Vectors.Cursor;
      Position : Count_Vectors.Cursor := To.First;
      Found    : Boolean              := False;
   begin
      while not Found and then Position /= Count_Vectors.No_Element loop
         declare
            Elements : Element_Array := Count_Vectors.Element (Position);
         begin
            for I in Elements'Range loop
               if Elements (I) = Item then
                  Found := True;
               end if;
            end loop;
         end;
         if not Found then
            Position := Count_Vectors.Next (Position);
         end if;
      end loop;
      if Position /= Count_Vectors.No_Element then
         -- element found, remove it and insert to next count
         declare
            New_Position : Count_Vectors.Cursor :=
               Count_Vectors.Next (Position);
         begin
            -- remove from old position
            declare
               Old_Elements : Element_Array :=
                  Count_Vectors.Element (Position);
               New_Elements : Element_Array (1 .. Old_Elements'Length - 1);
               New_Index    : Positive      := New_Elements'First;
            begin
               for I in Old_Elements'Range loop
                  if Old_Elements (I) /= Item then
                     New_Elements (New_Index) := Old_Elements (I);
                     New_Index                := New_Index + 1;
                  end if;
               end loop;
               To.Replace_Element (Position, New_Elements);
            end;
            -- new position not already there?
            if New_Position = Count_Vectors.No_Element then
               declare
                  New_Array : Element_Array (1 .. 1) := (1 => Item);
               begin
                  To.Append (New_Array);
               end;
            else
               -- add to new position
               declare
                  Old_Elements : Element_Array :=
                     Count_Vectors.Element (New_Position);
                  New_Elements : Element_Array (1 .. Old_Elements'Length + 1);
               begin
                  New_Elements (1 .. Old_Elements'Length) := Old_Elements;
                  New_Elements (New_Elements'Last)        := Item;
                  To.Replace_Element (New_Position, New_Elements);
               end;
            end if;
         end;
      else
         -- element not found, add to count 1
         Position := To.First;
         if Position = Count_Vectors.No_Element then
            declare
               New_Array : Element_Array (1 .. 1) := (1 => Item);
            begin
               To.Append (New_Array);
            end;
         else
            declare
               Old_Elements : Element_Array :=
                  Count_Vectors.Element (Position);
               New_Elements : Element_Array (1 .. Old_Elements'Length + 1);
            begin
               New_Elements (1 .. Old_Elements'Length) := Old_Elements;
               New_Elements (New_Elements'Last)        := Item;
               To.Replace_Element (Position, New_Elements);
            end;
         end if;
      end if;
   end Add;

   function Get_Mode (Set : Element_Array) return Element_Array is
      Counts : Count_Vectors.Vector;
   begin
      for I in Set'Range loop
         Add (Counts, Set (I));
      end loop;
      return Counts.Last_Element;
   end Get_Mode;

end Mode;

with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Recursive_Binary_Search is
   Not_Found : exception;

   generic
      type Index is range <>;
      type Element is private;
      type Array_Of_Elements is array (Index range <>) of Element;
      with function "<" (L, R : Element) return Boolean is <>;
   function Search (Container : Array_Of_Elements; Value : Element) return Index;

   function Search (Container : Array_Of_Elements; Value : Element) return Index is
      Mid : Index;
   begin
      if Container'Length > 0 then
         Mid := (Container'First + Container'Last) / 2;
         if Value < Container (Mid) then
            if Container'First /= Mid then
               return Search (Container (Container'First..Mid - 1), Value);
            end if;
         elsif Container (Mid) < Value then
            if Container'Last /= Mid then
               return Search (Container (Mid + 1..Container'Last), Value);
            end if;
         else
            return Mid;
         end if;
      end if;
      raise Not_Found;
   end Search;

   type Integer_Array is array (Positive range <>) of Integer;
   function Find is new Search (Positive, Integer, Integer_Array);

   procedure Test (X : Integer_Array; E : Integer) is
   begin
      New_Line;
      for I in X'Range loop
         Put (Integer'Image (X (I)));
      end loop;
      Put (" contains" & Integer'Image (E) & " at" & Integer'Image (Find (X, E)));
   exception
      when Not_Found =>
         Put (" does not contain" & Integer'Image (E));
   end Test;
begin
   Test ((2, 4, 6, 8, 9), 2);
   Test ((2, 4, 6, 8, 9), 1);
   Test ((2, 4, 6, 8, 9), 8);
   Test ((2, 4, 6, 8, 9), 10);
   Test ((2, 4, 6, 8, 9), 9);
   Test ((2, 4, 6, 8, 9), 5);
end Test_Recursive_Binary_Search;

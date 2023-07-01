with Ada.Text_Io; use Ada.Text_IO;

package body Abelian_Sandpile is

   ---------------
   -- Stabalize --
   ---------------

   procedure Stabalize (Pile : in out Sandpile) is
   begin
      while not Is_Stable(Pile) loop
         Topple(Pile);
      end loop;
   end Stabalize;

   ---------------
   -- Is_Stable --
   ---------------

   function Is_Stable (Pile : in Sandpile) return Boolean is
   begin
     return (for all E of Pile => E < Limit);
   end Is_Stable;

   ------------
   -- Topple --
   ------------

   procedure Topple (Pile : in out Sandpile) is
   begin
      outer:
      for Row in Pile'Range(1) loop
         for Col in Pile'Range(2) loop
            if Pile(Row, Col) >= Limit then
               Pile(Row, Col) := Pile(Row, Col) - Limit;
               if Row > 0 then
                  Pile(Row - 1, Col) := Pile(Row -1, Col) + 1;
               end if;
               if Row < Pile'Last(1) then
                  Pile(Row + 1, Col) := Pile(Row + 1, Col) + 1;
               end if;
               if Col > 0 then
                  Pile(Row, Col - 1) := Pile(Row, Col - 1) + 1;
               end if;
               if Col < Pile'Last(2) then
                  Pile(Row, Col + 1) := Pile(Row, Col + 1) + 1;
               end if;

               exit outer;
            end if;
         end loop;
      end loop outer;
   end Topple;

   ---------
   -- "+" --
   ---------

   function "+" (Left, Right : Sandpile) return Sandpile is
      Result : Sandpile;
   begin
      for I in Sandpile'Range(1) loop
         for J in Sandpile'Range(2) loop
            Result(I, J) := Left(I, J) + Right(I, J);
         end loop;
      end loop;
      Stabalize(Result);
      return Result;
   end "+";

   -----------
   -- Print --
   -----------

   procedure Print(Pile : in Sandpile) is
   begin
      for row in Pile'Range(1) loop
         for col in Pile'Range(2) loop
            Put(Integer'Image(Pile(row, col)));
         end loop;
         New_Line;
      end loop;
      New_Line;
   end Print;
end Abelian_Sandpile;

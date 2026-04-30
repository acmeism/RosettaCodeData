with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Text_IO;

procedure Abbreviations is

   package String_Vectors is
     new Ada.Containers.Indefinite_Vectors (Index_Type   => Positive,
                                            Element_Type => String);
   use Ada.Text_IO, String_Vectors;

   function Split (Line : String) return Vector is
      Result : Vector;
      First  : Natural;
      Last   : Natural := Line'First - 1;
   begin
      while Last + 1 in Line'Range loop
         Ada.Strings.Fixed.Find_Token
           (Line, Ada.Strings.Maps.To_Set (" "), Last + 1,
            Ada.Strings.Outside, First, Last);
         exit when Last = 0;
         Append (Result, Line (First .. Last));
      end loop;
      return Result;
   end Split;

   function Abbrev_Length (Items : Vector) return Natural is
      use type Ada.Containers.Count_Type;
      Max     : Natural := 0;
      Abbrevs : Vector;
   begin
      for Item of Items loop
         Max := Natural'Max (Max, Item'Length);
      end loop;

      for Length in 1 .. Max loop
         Abbrevs := Empty_Vector;
         for Item of Items loop
            declare
               Last : constant Natural
                 := Natural'Min (Item'Last, Item'First + Length - 1);

               Abbrev : String renames Item (Item'First .. Last);
            begin
               exit when Abbrevs.Contains (Abbrev);
               Abbrevs.Append (Abbrev);
            end;
         end loop;
         if Abbrevs.Length = Items.Length then
            return Length;
         end if;
      end loop;
      return 0;
   end Abbrev_Length;

   procedure Process (Line : String) is
      package Natural_IO is new Ada.Text_IO.Integer_IO (Natural);
      Words  : constant Vector  := Split (Line);
      Length : constant Natural := Abbrev_Length (Words);
   begin
      Natural_IO.Put (Length, Width => 2);
      Put (" ");
      Put_Line (Line);
   end Process;

begin
   while not End_Of_File loop
      Process (Get_Line);
   end loop;
end Abbreviations;

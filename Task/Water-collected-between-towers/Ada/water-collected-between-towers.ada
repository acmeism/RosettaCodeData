with Ada.Text_IO;

procedure Water_Collected is

   type Bar_Index     is new Positive;
   type Natural_Array is array (Bar_Index range <>) of Natural;

   subtype Bar_Array   is Natural_Array;
   subtype Water_Array is Natural_Array;

   function Flood (Bars : Bar_Array; Forward : Boolean) return Water_Array is
      R : Water_Array (Bars'Range);
      H : Natural := 0;
   begin
      if Forward then
         for A in R'Range loop
            H     := Natural'Max (H, Bars (A));
            R (A) := H - Bars (A);
         end loop;
      else
         for A in reverse R'Range loop
            H     := Natural'Max (H, Bars (A));
            R (A) := H - Bars (A);
         end loop;
      end if;
      return R;
   end Flood;

   function Fold (Left, Right : Water_Array) return Water_Array is
      R : Water_Array (Left'Range);
   begin
      for A in R'Range loop
         R (A) := Natural'Min (Left (A), Right (A));
      end loop;
      return R;
   end Fold;

   function Fill (Bars : Bar_Array) return Water_Array
   is (Fold (Flood (Bars, Forward => True),
             Flood (Bars, Forward => False)));

   function Sum_Of (Bars : Natural_Array) return Natural is
      Sum : Natural := 0;
   begin
      for Bar of Bars loop
         Sum := Sum + Bar;
      end loop;
      return Sum;
   end Sum_Of;

   procedure Show (Bars : Bar_Array) is
      use Ada.Text_IO;
      Water : constant Water_Array := Fill (Bars);
   begin
      Put ("The series: [");
      for Bar of Bars loop
         Put (Bar'Image);
         Put (" ");
      end loop;
      Put ("] holds ");
      Put (Sum_Of (Water)'Image);
      Put (" units of water.");
      New_Line;
   end Show;

begin
   Show ((1, 5, 3, 7, 2));
   Show ((5, 3, 7, 2, 6, 4, 5, 9, 1, 2));
   Show ((2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1));
   Show ((5, 5, 5, 5));
   Show ((5, 6, 7, 8));
   Show ((8, 7, 7, 6));
   Show ((6, 7, 10, 7, 6));
end Water_Collected;

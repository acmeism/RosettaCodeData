with Ada.Text_Io;                 use Ada.Text_Io;
with Ada.Numerics;                use Ada.Numerics;
with Ada.Numerics.Float_Random;   use Ada.Numerics.Float_Random;

procedure Counting_Sort is
   type Data is array (Integer range <>) of Natural;
   procedure Sort(Item : in out Data) is
      minValue, maxValue: Natural;
   begin
      minValue := Item(Item'First); maxValue := Item(Item'First);
      for I in Item'Range loop
         if Item(I) < minValue then minValue := Item(I); end if;
         if Item(I) > maxValue then maxValue := Item(I); end if;
      end loop;
      declare
         Count    : Data(minValue .. maxValue);
         itemPos  : Integer range Item'First - 1 .. Item'Last;
      begin
         for I in Count'Range loop
            Count(I) := 0;
         end loop;
         for I in Item'Range loop
            Count(Item(I)) := Count(Item(I)) + 1;
         end loop;
         itemPos := 0;
         for I in Count'Range loop
            for J in 1..Count(I) loop
               itemPos := itemPos + 1;
               Item(itemPos) := I;
            end loop;
         end loop;
      end;
   end Sort;
   Stuff : Data(1..30);
   Seed  : Generator;
begin
   Put("Before: ");
   for I in Stuff'Range loop
      Stuff(I) := Integer( Float'Truncation( Random( seed ) * 100.0 ) );
      Put(Natural'Image(Stuff(I)));
   end loop;
   New_Line;
   Sort(Stuff);
   Put("After : ");
   for I in Stuff'range loop
      Put(Natural'Image(Stuff(I)));
   end loop;
   New_Line;
end Counting_Sort;

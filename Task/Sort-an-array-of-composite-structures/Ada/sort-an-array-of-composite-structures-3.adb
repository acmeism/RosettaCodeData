with Ada.Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Sort_Composite is
   type Composite_Record is record
      Name : Unbounded_String;
      Value : Unbounded_String;
   end record;

   type Pairs_Array is array(Positive range <>) of Composite_Record;

   procedure Swap(Left, Right : in out Composite_Record) is
      Temp : Composite_Record := Left;
   begin
      Left := Right;
      Right := Temp;
   end Swap;

   -- Sort_Names uses a bubble sort

   procedure Sort_Name(Pairs : in out Pairs_Array) is
      Swap_Performed : Boolean := True;
   begin
      while Swap_Performed loop
         Swap_Performed := False;
         for I in Pairs'First..(Pairs'Last - 1) loop
            if Pairs(I).Name > Pairs(I + 1).Name then
               Swap (Pairs(I), Pairs(I + 1));
               Swap_Performed := True;
            end if;
         end loop;
      end loop;
   end Sort_Name;

   procedure Print(Item : Pairs_Array) is
   begin
      for I in Item'range loop
         Ada.Text_Io.Put_Line(To_String(Item(I).Name) & ", " &
            to_String(Item(I).Value));
      end loop;
   end Print;
   type Names is (Fred, Barney, Wilma, Betty, Pebbles);
   type Values is (Home, Work, Cook, Eat, Bowl);
   My_Pairs : Pairs_Array(1..5);
begin
   for I in My_Pairs'range loop
      My_Pairs(I).Name := To_Unbounded_String(Names'Image(Names'Val(Integer(I - 1))));
      My_Pairs(I).Value := To_Unbounded_String(Values'Image(Values'Val(Integer(I - 1))));
   end loop;
   Print(My_Pairs);
   Ada.Text_Io.Put_Line("=========================");
   Sort_Name(My_Pairs);
   Print(My_Pairs);
end Sort_Composite;

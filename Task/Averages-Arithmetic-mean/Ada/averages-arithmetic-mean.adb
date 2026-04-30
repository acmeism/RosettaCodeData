with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with Ada.Text_IO; use Ada.Text_IO;

procedure Mean_Main is
   type Vector is array (Positive range <>) of Float;
   function Mean (Item : Vector) return float with pre => Item'length > 0;
   function Mean (Item : Vector) return Float is
      Sum : Float := 0.0;
   begin
      for I in Item'range loop
         Sum := Sum + Item(I);
      end loop;
	  return Sum / Float(Item'Length);
   end Mean;
   A : Vector := (3.0, 1.0, 4.0, 1.0, 5.0, 9.0);
begin
    Put(Item => Mean (A), Fore => 1, Exp => 0);
   New_Line;
   -- test for zero length vector
   Put(Item => Mean(A (1..0)), Fore => 1, Exp => 0);
   New_Line;
end Mean_Main;

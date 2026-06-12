-- Generate the integers 1 .. 20 in random order
-- J. Carter     2023 Apr

with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

procedure Random_20 is
   subtype Desired_Value is Integer range 1 .. 20;

   package Desired_Random is new Ada.Numerics.Discrete_Random (Result_Subtype => Desired_Value);

   type Desired_List is array (Desired_Value) of Desired_Value;

   List : Desired_List;
   Gen  : Desired_Random.Generator;
   Idx  : Desired_Value;
begin -- Random_20
   Fill : for I in List'Range loop
      List (I) := I;
   end loop Fill;

   Desired_Random.Reset (Gen => Gen);

   Randomize : for I in List'Range loop
      Idx := Desired_Random.Random (Gen);

      Swap : declare
         Temp : Desired_Value := List (Idx);
      begin -- Swap
         List (Idx) := List (I);
         List (I) := Temp;
      end Swap;
   end loop Randomize;

   Print : for V of List loop
      Ada.Text_IO.Put (Item => V'Image);
   end loop Print;

   Ada.Text_IO.New_Line;
end Random_20;

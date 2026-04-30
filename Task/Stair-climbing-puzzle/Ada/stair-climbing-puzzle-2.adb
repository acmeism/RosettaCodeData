with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

procedure Scaffolding is
   package Try is new Ada.Numerics.Discrete_Random (Boolean);
   use Try;
   Dice  : Generator;
   Level : Integer := 0;

   function Step return Boolean is
   begin
      if Random (Dice) then
         Level := Level + 1;
         Ada.Text_IO.Put_Line ("Climbed up to" & Integer'Image (Level));
         return True;
      else
         Level := Level - 1;
         Ada.Text_IO.Put_Line ("Fell down to" & Integer'Image (Level));
         return False;
      end if;
   end Step;

   procedure Step_Up is
   begin
      while not Step loop
         Step_Up;
      end loop;
   end Step_Up;
begin
   Reset (Dice);
   Step_Up;
end Scaffolding;

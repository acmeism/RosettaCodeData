with Ada.Numerics.Float_Random;  use Ada.Numerics.Float_Random;
with Ada.Text_IO;                use Ada.Text_IO;

with Synchronization.Generic_Mutexes_Array;

procedure Test_Dining_Philosophers is
   type Philosopher is (Aristotle, Kant, Spinoza, Marx, Russel);
   package Fork_Arrays is new Synchronization.Generic_Mutexes_Array (Philosopher);
   use Fork_Arrays;

   Life_Span : constant := 20;    -- In his life a philosopher eats 20 times
   Forks : aliased Mutexes_Array; -- Forks for hungry philosophers

   function Left_Of (Fork : Philosopher) return Philosopher is
   begin
      if Fork = Philosopher'First then
         return Philosopher'Last;
      else
         return Philosopher'Pred (Fork);
      end if;
   end Left_Of;

   task type Person (ID : Philosopher);
   task body Person is
      Cutlery : aliased Mutexes_Set := ID or Left_Of (ID);
      Dice    : Generator;
   begin
      Reset (Dice);
      for Life_Cycle in 1..Life_Span loop
         Put_Line (Philosopher'Image (ID) & " is thinking");
         delay Duration (Random (Dice) * 0.100);
         Put_Line (Philosopher'Image (ID) & " is hungry");
         declare
            Lock : Set_Holder (Forks'Access, Cutlery'Access);
         begin
            Put_Line (Philosopher'Image (ID) & " is eating");
            delay Duration (Random (Dice) * 0.100);
         end;
      end loop;
      Put_Line (Philosopher'Image (ID) & " is leaving");
   end Person;

   Ph_1 : Person (Aristotle); -- Start philosophers
   Ph_2 : Person (Kant);
   Ph_3 : Person (Spinoza);
   Ph_4 : Person (Marx);
   Ph_5 : Person (Russel);
begin
   null; -- Nothing to do in the main task, just sit and behold
end Test_Dining_Philosophers;

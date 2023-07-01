with Ada.Numerics.Float_Random;  use Ada.Numerics.Float_Random;
with Ada.Text_IO;                use Ada.Text_IO;

procedure Test_Dining_Philosophers is
   type Philosopher is (Aristotle, Kant, Spinoza, Marx, Russel);
   protected type Fork is
      entry Grab;
      procedure Put_Down;
   private
      Seized : Boolean := False;
   end Fork;
   protected body Fork is
      entry Grab when not Seized is
      begin
         Seized := True;
      end Grab;
      procedure Put_Down is
      begin
         Seized := False;
      end Put_Down;
   end Fork;

   Life_Span : constant := 20;    -- In his life a philosopher eats 20 times

   task type Person (ID : Philosopher; First, Second : not null access Fork);
   task body Person is
      Dice : Generator;
   begin
      Reset (Dice);
      for Life_Cycle in 1..Life_Span loop
         Put_Line (Philosopher'Image (ID) & " is thinking");
         delay Duration (Random (Dice) * 0.100);
         Put_Line (Philosopher'Image (ID) & " is hungry");
         First.Grab;
         Second.Grab;
         Put_Line (Philosopher'Image (ID) & " is eating");
         delay Duration (Random (Dice) * 0.100);
         Second.Put_Down;
         First.Put_Down;
      end loop;
      Put_Line (Philosopher'Image (ID) & " is leaving");
   end Person;

   Forks : array (1..5) of aliased Fork; -- Forks for hungry philosophers
                                         -- Start philosophers
   Ph_1 : Person (Aristotle, Forks (1)'Access, Forks (2)'Access);
   Ph_2 : Person (Kant,      Forks (2)'Access, Forks (3)'Access);
   Ph_3 : Person (Spinoza,   Forks (3)'Access, Forks (4)'Access);
   Ph_4 : Person (Marx,      Forks (4)'Access, Forks (5)'Access);
   Ph_5 : Person (Russel,    Forks (1)'Access, Forks (5)'Access);
begin
   null; -- Nothing to do in the main task, just sit and behold
end Test_Dining_Philosophers;

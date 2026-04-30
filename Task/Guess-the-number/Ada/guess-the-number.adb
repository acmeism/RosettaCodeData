with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
procedure Guess_Number is
   subtype Number is Integer range 1 .. 10;
   package Number_IO is new Ada.Text_IO.Integer_IO (Number);
   package Number_RNG is new Ada.Numerics.Discrete_Random (Number);
   Generator  : Number_RNG.Generator;
   My_Number  : Number;
   Your_Guess : Number;
begin
   Number_RNG.Reset (Generator);
   My_Number := Number_RNG.Random (Generator);
   Ada.Text_IO.Put_Line ("Guess my number!");
   loop
      Ada.Text_IO.Put ("Your guess: ");
      Number_IO.Get (Your_Guess);
      exit when Your_Guess = My_Number;
      Ada.Text_IO.Put_Line ("Wrong, try again!");
   end loop;
   Ada.Text_IO.Put_Line ("Well guessed!");
end Guess_Number;

-------------------------------------------------------------------------------------------------------
-- Another version ------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

-- procedure main - begins program execution
procedure main is
guess : Integer := 0;
counter : Integer := 0;
theNumber : Integer := 0;

-- function generate number - creates and returns a random number between the
-- ranges of 1 to 100
function generateNumber return Integer is
   type randNum is new Integer range 1 .. 100;
   package Rand_Int is new Ada.Numerics.Discrete_Random(randNum);
   use Rand_Int;
   gen : Generator;
   numb : randNum;

begin
   Reset(gen);

   numb := Random(gen);

   return Integer(numb);
end generateNumber;

-- procedure intro - prints text welcoming the player to the game
procedure intro is
begin
   Put_Line("Welcome to Guess the Number");
   Put_Line("===========================");
   New_Line;

   Put_Line("Try to guess the number. It is in the range of 1 to 100.");
   Put_Line("Can you guess it in the least amount of tries possible?");
   New_Line;
end intro;

begin
   New_Line;

   intro;
   theNumber := generateNumber;

   -- main game loop
   while guess /= theNumber loop
      Put("Enter a guess: ");
      guess := integer'value(Get_Line);

      counter := counter + 1;

      if guess > theNumber then
         Put_Line("Too high!");
      elsif guess < theNumber then
         Put_Line("Too low!");
      end if;
   end loop;

   New_Line;

   Put_Line("CONGRATULATIONS! You guessed it!");
   Put_Line("It took you a total of " & integer'image(counter) & " attempts.");

   New_Line;
end main;

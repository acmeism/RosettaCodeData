-- The program is written in the programming language Ada. The name "Ada"
-- has been chosen in honour of your friend,
--      Augusta Ada King-Noel, Countess of Lovelace (née Byron).
--
-- This is an program to search for the smallest integer X, such that
-- (X*X) mod 1_000_000 = 269_696.
--
-- In the Ada language, "*" represents the multiplication symbol, "mod" the
-- modulo reduction, and the underscore "_" after every third digit in
-- literals is supposed to simplify reading numbers for humans.
-- Everything written after "--" in a line is a comment for the human,
-- and will be ignored by the computer.

with Ada.Text_IO;
-- We need this to tell the computer how it will later output its result.

procedure Babbage_Problem is

   -- We know that 99_736*99_736 is 9_947_269_696. This implies:
   -- 1. The smallest X with X*X mod 1_000_000 = 269_696 is at most 99_736.
   -- 2. The largest square X*X, which the program may have to deal with,
   --    will be at most 9_947_269_69.

   type Number is range 1 .. 99_736*99_736;
   X: Number := 1;
   -- X can store numbers between 1 and 99_736*99_736. Computations
   -- involving X can handle intermediate results in that range.
   -- Initially the value stored at X is 1.
   -- When running the program, the value will become 2, 3, 4, etc.

begin
   -- The program starts running.

   -- The computer first squares X, then it truncates the square, such
   -- that the result is a six-digit number.
   -- Finally, the computer checks if this number is 269_696.
   while not (((X*X) mod 1_000_000) = 269_696) loop

      -- When the computer goes here, the number was not 269_696.
      X := X+1;
      -- So we replace X by X+1, and then go back and try again.

   end loop;

   -- When the computer eventually goes here, the number is 269_696.
   -- E.e., the value stored at X is the value we are searching for.
   -- We still have to print out this value.

   Ada.Text_IO.Put_Line(Number'Image(X));
   -- Number'Image(X) converts the value stored at X into a string of
   -- printable characters (more specifically, of digits).
   -- Ada.Text_IO.Put_Line(...) prints this string, for humans to read.
   -- I did already run the program, and it did print out 25264.
end Babbage_Problem;

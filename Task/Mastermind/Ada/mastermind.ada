with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Strings.Fixed;
with Ada.Containers.Ordered_Sets;

use Ada.Strings.Fixed;

procedure MasterMind
is
   subtype Color_Number is Positive range 2 .. 20;
   subtype Code_Size is Positive range 4 .. 10;
   subtype Guesses_Number is Positive range 7 .. 20;
   subtype Color is Character range 'A' .. 'T';

   function Hint(correct, guess : in String) return String
   is
      Xs : Natural := 0;
      Os : Natural := 0;
      to_display : String(1 .. correct'Length) := (others => '-');
   begin
      for I in guess'Range loop
         if guess(I) = correct(I) then
            Xs := Xs + 1;
            to_display(I) := 'X';
         end if;
      end loop;
      for I in guess'Range loop
         if to_display(I) = '-' then
            for J in correct'Range loop
               if J /= I and to_display(J) /= 'X' and correct(J) = guess(I) then
                  Os := Os + 1;
                  exit;
               end if;
            end loop;
         end if;
      end loop;
      return Xs * 'X' & Os * 'O' & (guess'Length - Xs - Os) * '-';
   end Hint;

   generic
      type Data is (<>);
   function Input(message : in String) return Data;
   -- Input will loop until a correct value is given by the user.
   -- For each wrong input, the program will prompt the range of expected values.

   function Input(message : in String) return Data is
   begin
      loop
         Ada.Text_IO.Put(message);
         declare
            S : constant String := Ada.Text_IO.Get_Line;
         begin
            return Data'Value(S);
         exception
            when Constraint_Error =>
               Ada.Text_IO.New_Line;
               Ada.Text_IO.Put_Line("Invalid input!");
               Ada.Text_IO.Put_Line
                 ("Expected values in range:"
                  & Data'First'Img & " .." & Data'Last'Img);
               Ada.Text_IO.New_Line;
         end;
      end loop;
   end;

   function Input_Color_Number is new Input(Color_Number);
   function Input_Code_Size is new Input(Code_Size);
   function Input_Guesses_Number is new Input(Guesses_Number);
   function Input_Boolean is new Input(Boolean);

   CN : constant Color_Number := Input_Color_Number("How many colors? ");
   GN : constant Guesses_Number := Input_Guesses_Number("How many guesses? ");
   CS : constant Code_Size := Input_Code_Size("Size of the code? ");
   repeats : Boolean := Input_Boolean("With repeats? ");
   -- Not constant: if Color < Code_Size, we will have repetitions anyway.

   subtype Actual_Colors is Color range Color'First .. Color'Val(Color'Pos(Color'First) + CN - 1);
   package Actual_Colors_Sets is new Ada.Containers.Ordered_Sets(Element_Type => Actual_Colors);

   package Color_Random is new Ada.Numerics.Discrete_Random(Result_Subtype => Actual_Colors);
   generator : Color_Random.Generator;

   function Random return String
   is
      C : String(1 .. CS);
      seen : Actual_Colors_Sets.Set;
   begin
      for I in C'Range loop
         C(I) := Color_Random.Random(generator);
         while (not repeats) and seen.Contains(C(I)) loop
            C(I) := Color_Random.Random(generator);
         end loop;
         seen.Include(C(I));
      end loop;
      return C;
   end Random;

   function Get_Code return String is
   begin
      loop
         Ada.Text_IO.Put("> ");
         declare
            input : constant String := Ada.Text_IO.Get_Line;
         begin
            if input'Length /= CS then
               raise Constraint_Error;
            end if;
            for C of input loop
               if C not in Actual_Colors then
                  raise Constraint_Error;
               end if;
            end loop;
            return input;
         exception
            when Constraint_Error =>
               Ada.Text_IO.New_Line;
               Ada.Text_IO.Put_Line("Invalid input!");
               Ada.Text_IO.New_Line;
         end;
      end loop;
   end Get_Code;

   found : Boolean := False;
begin
   if (not repeats) and (CN < CS) then
      Ada.Text_IO.Put_Line("Not enough colors! Using repeats anyway.");
      repeats := True;
   end if;

   Color_Random.Reset(generator);

   declare
      answer : constant String := Random;
      previous : array(1 .. GN) of String(1 .. CS*2);
   begin
      for I in 1 .. GN loop
         declare
            guess : constant String := Get_Code;
         begin
            if guess = answer then
               Ada.Text_IO.Put_Line("You won, congratulations!");
               found := True;
            else
               previous(I) := guess & Hint(answer, guess);
               Ada.Text_IO.Put_Line(44 * '-');
               for J in 1 .. I loop
                  Ada.Text_IO.Put_Line
                    (previous(J)(1 .. CS)
                     & " => " & previous(J)(CS+1 .. previous(J)'Last));
               end loop;
               Ada.Text_IO.Put_Line(44 * '-');
               Ada.Text_IO.New_Line;
            end if;
         end;
         exit when found;
      end loop;
      if not found then
         Ada.Text_IO.Put_Line("You lost, sorry! The answer was: " & answer);
      end if;
   end;
end MasterMind;

pragma Ada_2022;                    --  enables Ada 2022 features

--  Ada has a lot of safety checks that are turned on by default.
--  It is possible to turn them off, especially when you know they aren't needed,
--  but this should be done only when you've done your homework.
--  Turning this one off makes the program nearly 30x slower on my machine;
--  you may want to see how it works differently on yours.
pragma Suppress (All_Checks);
--  pragma Suppress (Tampering_Check);

with Ada.Containers.Vectors;

with Ada.Real_Time;
use all type Ada.Real_Time.Time_Span;  --  makes Time_Span's operators public

with Ada.Text_IO;

procedure Ulam_Numbers is

   package IO renames Ada.Text_IO;

   package IntVecs is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Natural);
   subtype IntVec is IntVecs.Vector;

   Something_Went_Wrong : exception;

   function Ulam (Nth : Positive) return Positive is
      Numbers, Sieve : IntVec;
      Ith            : Positive := 2;
   begin
      --  initialize
      Numbers.Append (1);
      Numbers.Append (2);
      Sieve.Append (1);
      Sieve.Append (1);

      --  main loop
      while Positive (Numbers.Length) < Nth loop

         declare
            Old_Length : constant Positive := Positive (Sieve.Length) + 1;
            Extend_To  : constant Positive :=
              Ith + Numbers (Numbers.Last_Index);
         begin

            --  extend sieve
            Sieve.Set_Length (Ada.Containers.Count_Type (Extend_To));
            for Jth in Old_Length .. Extend_To loop
               Sieve (Jth) := 0;
            end loop;

            for Number of Numbers loop
               Sieve (Ith + Number) := Sieve (Ith + Number) + 1;
            end loop;
            Sieve (Ith + Numbers.Last_Element) :=
              Sieve (Ith + Numbers.Last_Element) - 1;

            Ith := Sieve.Find_Index (1, Ith + 1);
            if Ith > Positive (Sieve.Length) then
               raise Something_Went_Wrong with "Iteration" & Ith'Image;
            end if;
            Numbers.Append (Ith);

         end;

      end loop;

      return Numbers.Last_Element;

   end Ulam;

   Start, Stop : Ada.Real_Time.Time;
   Total_Time  : Ada.Real_Time.Time_Span := Ada.Real_Time.Time_Span_Zero;

   Entries_To_Compute : constant array (Positive range <>) of Integer :=
     [10, 100, 1_000, 10_000, 100_000];

begin

   Start := Ada.Real_Time.Clock;

   for Ith of Entries_To_Compute loop
      IO.Put_Line ("The" & Ith'Image & "th Ulam number is" & Ulam (Ith)'Image);
   end loop;

   Stop       := Ada.Real_Time.Clock;
   Total_Time := (@ + Stop) - Start;
   IO.Put_Line ("Elapsed time: " & Total_Time'Image);

end Ulam_Numbers;

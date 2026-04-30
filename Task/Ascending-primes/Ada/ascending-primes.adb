pragma Ada_2022;

with Ada.Text_IO;
with Ada.Containers.Vectors;
with Fifo;

procedure Ascending_Primes is

   subtype Prime is Positive range 2 .. Positive'Last with
       Dynamic_Predicate =>
       (for all I in 2 .. (Prime / 2) => (Prime mod I) /= 0);

   package Prime_Vectors is new
     Ada.Containers.Vectors
       (Index_Type => Natural,
       Element_Type => Prime);

   package Positive_Fifo is new Fifo (Positive);
   use Positive_Fifo;

   --  Helper queue and vector for primes found
   Queue : Fifo_Type;
   Primes : Prime_Vectors.Vector;

begin
   --  Initialise the queue with the first nine numbers
   for Index in 1 .. 9 loop
      Queue.Push (Index);
   end loop;

   --  Read the canditate numbers from the queue
   --  check if they are prime and generate
   --  the next possible candidates from them
   while not Queue.Is_Empty loop
      declare
         Candidate  : Positive;
         Next_Digit : Positive;
      begin
         Queue.Pop (Candidate);

         if Candidate in Prime then
            Primes.Append (Candidate);
         end if;

         --  Generate the next possible candidates
         --  from the current one
         Next_Digit := Candidate mod 10 + 1;
         while Next_Digit <= 9 loop
            Queue.Push (Candidate * 10 + Next_Digit);
            Next_Digit := @ + 1;
         end loop;

      end;
   end loop;

   --  Print the final list of prime numbers
   for P of Primes loop
      Ada.Text_IO.Put (P'Image);
   end loop;
   Ada.Text_IO.New_Line;

end Ascending_Primes;

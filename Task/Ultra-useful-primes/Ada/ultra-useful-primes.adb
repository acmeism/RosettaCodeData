with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

procedure Ultra_Useful_Primes is
   Count : Integer := 16;

   function Find (N : Positive) return Positive is
      P : Unbounded_Unsigned := Power_Of_Two (2 ** N);
   begin
      for K in 1..Positive'Last loop
         Sub (P, 1);
         if Is_Prime (P, 10) = Prime then
            return K;
         end if;
      end loop;
      return 1; -- Never get here
   end Find;
begin
   Put ("a(n):");
   for N in 1..10 loop
      Put (Integer'Image (Find (N)));
   end loop;
   New_Line;
end Ultra_Useful_Primes;

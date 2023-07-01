with Ada.Text_IO;  use Ada.Text_IO;

procedure Gapful_Numbers is

   function Divisor (N : in Positive) return Positive is
      NN : Positive := N;
   begin
      while NN >= 10 loop
         NN := NN / 10;
      end loop;
      return 10 * NN + (N mod 10);
   end Divisor;

   function Is_Gapful (N : in Positive) return Boolean is
   begin
      return N mod Divisor (N) = 0;
   end Is_Gapful;

   procedure Find_Gapful (Count : in Positive; From : in Positive) is
      Found : Natural := 0;
   begin
      for Candidate in From .. Positive'Last loop
         if Is_Gapful (Candidate) then
            Put (Candidate'Image);
            Found := Found + 1;
            exit when Found = Count;
         end if;
      end loop;
      New_Line;
   end Find_Gapful;

begin
   Put_Line ("First 30 gapful numbers over 100:");
   Find_Gapful (From => 100, Count => 30);
   New_Line;

   Put_Line ("First 15 gapful numbers over 1_000_000:");
   Find_Gapful (From => 1_000_000, Count => 15);
   New_Line;

   Put_Line ("First 10 gapful numbers over 1_000_000_000:");
   Find_Gapful (From => 1_000_000_000, Count => 10);
   New_Line;
end Gapful_Numbers;

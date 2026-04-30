with Ada.Text_IO;
package body Prime_Numbers is

   procedure Put (List : Number_List) is
   begin
      for Index in List'Range loop
         Ada.Text_IO.Put (Image (List (Index)));
      end loop;
   end Put;

   task body Calculate_Factors is
      Size : Natural := 0;
      N    : Number;
      M    : Number;
      K    : Number  := Two;
   begin
      accept Start (The_Number : in Number) do
         N := The_Number;
         M := N;
      end Start;
      -- Estimation of the result length from above
      while M >= Two loop
         M    := (M + One) / Two;
         Size := Size + 1;
      end loop;
      M := N;
      -- Filling the result with prime numbers
      declare
         Result : Number_List (1 .. Size);
         Index  : Positive := 1;
      begin
         while N >= K loop -- Divisors loop
            while Zero = (M mod K) loop -- While divides
               Result (Index) := K;
               Index          := Index + 1;
               M              := M / K;
            end loop;
            K := K + One;
         end loop;
         Index := Index - 1;
         accept Get_Size (Size : out Natural) do
            Size := Index;
         end Get_Size;
         accept Get_Result (List : out Number_List) do
            List (1 .. Index) := Result (1 .. Index);
         end Get_Result;
      end;
   end Calculate_Factors;

end Prime_Numbers;

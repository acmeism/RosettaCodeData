with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Prime is
   generic
      type Number is private;
      Zero : Number;
      One  : Number;
      Two  : Number;
      with function Image (X : Number) return String is <>;
      with function "+"   (X, Y : Number) return Number is <>;
      with function "/"   (X, Y : Number) return Number is <>;
      with function "mod" (X, Y : Number) return Number is <>;
      with function ">="  (X, Y : Number) return Boolean is <>;
   package Prime_Numbers is
      type Number_List is array (Positive range <>) of Number;
      function Decompose (N : Number) return Number_List;
      procedure Put (List : Number_List);
   end Prime_Numbers;

   package body Prime_Numbers is
      function Decompose (N : Number) return Number_List is
         Size : Natural := 0;
         M    : Number  := N;
         K    : Number  := Two;
      begin
         -- Estimation of the result length from above
         while M >= Two loop
            M := (M + One) / Two;
            Size := Size + 1;
         end loop;
         M := N;
         -- Filling the result with prime numbers
         declare
            Result : Number_List (1..Size);
            Index  : Positive := 1;
         begin
            while N >= K loop -- Divisors loop
               while Zero = (M mod K) loop -- While divides
                  Result (Index) := K;
                  Index := Index + 1;
                  M := M / K;
               end loop;
               K := K + One;
            end loop;
            return Result (1..Index - 1);
         end;
      end Decompose;

      procedure Put (List : Number_List) is
      begin
         for Index in List'Range loop
            Put (Image (List (Index)));
         end loop;
      end Put;
   end Prime_Numbers;
   package Integer_Numbers is new Prime_Numbers (Natural, 0, 1, 2, Positive'Image);
   use Integer_Numbers;
begin
   Put (Decompose (12));
end Test_Prime;

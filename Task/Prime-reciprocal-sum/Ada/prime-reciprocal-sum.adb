with Ada.Text_IO;                 use Ada.Text_IO;

with Unbounded_Integers;          use Unbounded_Integers;
with Unbounded_Rationals;         use Unbounded_Rationals;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

with Strings_Edit.Unbounded_Rational_Edit;
use  Strings_Edit.Unbounded_Rational_Edit;

procedure Prime_Reciprocal_Sum is

   Count : Natural := 0;
   Sum   : Unbounded_Rational := Unbounded_Rationals.One / 2;
   P     : Unbounded_Unsigned := Unbounded_Unsigneds.Two;
   function "+" (N : Unbounded_Unsigned) return String is
      Result : constant String := Image (N);
   begin
      if Result'Length > 60 then
         return Result (1..20)                         &
                "..."                                  &
                Result (Result'Last - 19..Result'Last) &
                Integer'Image (Result'Length)          &
                " digits";
      else
         return Result;
      end if;
   end "+";
begin
   Put_Line ("2");
   while Count <= 13 loop
      P := Get_Mantissa (Ceiling (Invert (1 - Sum)));
      if Is_Even (P) then
         Add (P, 1);
      end if;
      loop
         if Is_Prime (P, 10) = Prime then
            Sum := Sum + Unbounded_Rationals.One / P;
            Put_Line (+P);
            Count := Count + 1;
            exit;
         end if;
         Add (P, 2);
      end loop;
   end loop;
end Prime_Reciprocal_Sum;

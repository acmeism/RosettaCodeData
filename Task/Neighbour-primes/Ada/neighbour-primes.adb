with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Neighbour_Primes is
   P       : Unbounded_Unsigned := Three;
   Q, R    : Unbounded_Unsigned;
   Line    : String (1..80);
   Pointer : Integer := 1;
begin
   Put_Line ("  p   q pq + 2");
   Put_Line ("--------------");
   loop
      Q := Next_Prime (P, 10);
      R := P * Q + 2;
      if Is_Prime (R, 10) = Prime then
         Pointer := 1;
         Put (Line, Pointer, P, 10, 3, Strings_Edit.Right);
         Put (Line, Pointer, Q, 10, 4, Strings_Edit.Right);
         Put (Line, Pointer, R, 10, 7, Strings_Edit.Right);
         Put_Line (Line (1..Pointer - 1));
      end if;
      exit when P >= 500;
      Swap (P, Q);
   end loop;
end Neighbour_Primes;

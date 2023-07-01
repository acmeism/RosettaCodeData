with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO;            use Ada.Text_IO;
with Interfaces;             use Interfaces;

procedure Long_Multiplication is
   -- Insert definitions above here
   procedure Put (Value : Long_Number) is
      X      : Long_Number := Value;
      Last   : Natural     := X'Last;
      Digit  : Unsigned_32;
      Result : Unbounded_String;
   begin
      loop
         Div (X, Last, Digit, 10);
         Append (Result, Character'Val (Digit + Character'Pos ('0')));
         exit when Last = 0 and then X (0) = 0;
      end loop;
      for Index in reverse 1..Length (Result) loop
         Put (Element (Result, Index));
      end loop;
   end Put;

   X : Long_Number := (0 => 0, 1 => 0, 2 => 1) * (0 => 0, 1 => 0, 2 => 1);
begin
   Put (X);
end Long_Multiplication;

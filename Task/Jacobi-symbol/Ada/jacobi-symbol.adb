with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;
with Strings_Edit.Integers;

procedure Jacobi_Symbol is
   Line    : String (1..100);
   Pointer : Integer;
begin
   Put_Line ("K/N |  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20");
   Put_Line ("----+------------------------------------------------------------");
   for K in Half_Word range 1..15 loop
      Pointer := 1;
      Strings_Edit.Integers.Put
      (  Destination => Line,
         Pointer     => Pointer,
         Value       => Integer (2 * K - 1),
         Field    => 3,
         Justify  => Strings_Edit.Right,
         Fill     => ' '
      );
      Strings_Edit.Put (Line, Pointer, " |");
      for N in Half_Word range 1..20 loop
         Strings_Edit.Integers.Put
         (  Destination => Line,
            Pointer     => Pointer,
            Value       => Jacobi_Symbol
                           (  From_Half_Word (N),
                              From_Half_Word (2 * K - 1)
                           ),
            Field       => 3,
            Justify     => Strings_Edit.Right,
            Fill        => ' '
         );
      end loop;
      Put_Line (Line (1..Pointer - 1));
   end loop;
end Jacobi_Symbol;

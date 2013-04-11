procedure Div
          (  Dividend  : in out Long_Number;
             Last      : in out Natural;
             Remainder : out Unsigned_32;
             Divisor   : Unsigned_32
          )  is
   Div   : constant Unsigned_64 := Unsigned_64 (Divisor);
   Accum : Unsigned_64 := 0;
   Size  : Natural     := 0;
begin
   for Index in reverse Dividend'First..Last loop
      Accum := Accum * 2**32 + Unsigned_64 (Dividend (Index));
      Dividend (Index) := Unsigned_32 (Accum / Div);
      if Size = 0 and then Dividend (Index) /= 0 then
         Size := Index;
      end if;
      Accum := Accum mod Div;
   end loop;
   Remainder := Unsigned_32 (Accum);
   Last := Size;
end Div;

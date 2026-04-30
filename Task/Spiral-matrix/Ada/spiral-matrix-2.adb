function Spiral (N : Positive) return Array_Type is
   Result : Array_Type (1..N, 1..N);
   Left   : Positive := 1;
   Right  : Positive := N;
   Top    : Positive := 1;
   Bottom : Positive := N;
   Index  : Natural  := 0;
begin
   while Left < Right loop
      for I in Left..Right - 1 loop
         Result (Top, I) := Index;
         Index := Index + 1;
      end loop;
      for J in Top..Bottom - 1 loop
         Result (J, Right) := Index;
         Index := Index + 1;
      end loop;
      for I in reverse Left + 1..Right loop
         Result (Bottom, I) := Index;
         Index := Index + 1;
      end loop;
      for J in reverse Top + 1..Bottom loop
         Result (J, Left) := Index;
         Index := Index + 1;
      end loop;
      Left   := Left   + 1;
      Right  := Right  - 1;
      Top    := Top    + 1;
      Bottom := Bottom - 1;
   end loop;
   Result (Top, Left) := Index;
   return Result;
end Spiral;

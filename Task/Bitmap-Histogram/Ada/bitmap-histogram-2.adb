function Median (H : Histogram) return Luminance is
   From  : Luminance   := Luminance'First;
   To    : Luminance   := Luminance'Last;
   Left  : Pixel_Count := H (From);
   Right : Pixel_Count := H (To);
begin
   while From /= To loop
      if Left < Right then
         From := From + 1;
         Left := Left + H (From);
      else
         To    := To    - 1;
         Right := Right + H (To);
      end if;
   end loop;
   return From;
end Median;

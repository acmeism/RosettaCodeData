function Color (Picture : Grayscale_Image) return Image is
   Result : Image (Picture'Range (1), Picture'Range (2));
begin
   for I in Picture'Range (1) loop
      for J in Picture'Range (2) loop
         Result (I, J) := (others => Picture (I, J));
      end loop;
   end loop;
   return Result;
end Color;

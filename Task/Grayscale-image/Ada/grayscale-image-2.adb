function Grayscale (Picture : Image) return Grayscale_Image is
   type Extended_Luminance is range 0..10_000_000;
   Result : Grayscale_Image (Picture'Range (1), Picture'Range (2));
   Color  : Pixel;
begin
   for I in Picture'Range (1) loop
      for J in Picture'Range (2) loop
         Color := Picture (I, J);
         Result (I, J) :=
            Luminance
            (  (  2_126 * Extended_Luminance (Color.R)
               +  7_152 * Extended_Luminance (Color.G)
               +    722 * Extended_Luminance (Color.B)
               )
            /  10_000
            );
      end loop;
   end loop;
   return Result;
end Grayscale;

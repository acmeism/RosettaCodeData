type Pixel_Count is mod 2**64;
type Histogram is array (Luminance) of Pixel_Count;

function Get_Histogram (Picture : Grayscale_Image) return Histogram is
   Result : Histogram := (others => 0);
begin
   for I in Picture'Range (1) loop
      for J in Picture'Range (2) loop
         declare
            Count : Pixel_Count renames Result (Picture (I, J));
         begin
            Count := Count + 1;
         end;
      end loop;
   end loop;
   return Result;
end Get_Histogram;

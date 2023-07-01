function "-" (Left, Right : Pixel) return Count is
begin
   return (Left.R - Right.R) + (Left.G - Left.G) + (Left.B - Right.B);
end "-";

type Float_Luminance is new Float;

type Float_Pixel is record
   R, G, B : Float_Luminance := 0.0;
end record;

function "*" (Left : Float_Pixel; Right : Float_Luminance) return Float_Pixel is
   pragma Inline ("*");
begin
   return (Left.R * Right, Left.G * Right, Left.B * Right);
end "*";

function "+" (Left, Right : Float_Pixel) return Float_Pixel is
   pragma Inline ("+");
begin
   return (Left.R + Right.R, Left.G + Right.G, Left.B + Right.B);
end "+";

function To_Luminance (X : Float_Luminance) return Luminance is
   pragma Inline (To_Luminance);
begin
   if X <= 0.0 then
      return 0;
   elsif X >= 255.0 then
      return 255;
   else
      return Luminance (X);
   end if;
end To_Luminance;

function To_Pixel (X : Float_Pixel) return Pixel is
   pragma Inline (To_Pixel);
begin
   return (To_Luminance (X.R), To_Luminance (X.G), To_Luminance (X.B));
end To_Pixel;

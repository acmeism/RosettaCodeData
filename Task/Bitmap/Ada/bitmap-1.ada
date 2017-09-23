package Bitmap_Store is
   type Luminance is mod 2**8;
   type Pixel is record
      R, G, B : Luminance := Luminance'First;
   end record;
   Black : constant Pixel := (others => Luminance'First);
   White : constant Pixel := (others => Luminance'Last);
   type Image is array (Positive range <>, Positive range <>) of Pixel;

   procedure Fill (Picture : in out Image; Color : Pixel);

   procedure Print (Picture : Image);

   type Point is record
      X, Y : Positive;
   end record;
end Bitmap_Store;

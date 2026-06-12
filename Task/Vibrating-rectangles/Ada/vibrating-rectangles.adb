--  modern Ada
pragma Ada_2022;
--  extra-modern Ada ;-)
pragma Extensions_Allowed (On);

--  imports
with Rasters;

procedure Vibrating_Rectangles is

   Dimension : constant Positive := 256;
   --  canvas size
   Step      : constant Positive := Integer'Max (1, 256 / (Dimension / 2));
   --  amount to step the color each frame

   package R is new Rasters.RGB_Raster
     (Width => Dimension, Height => Dimension);
   --  initialize a new raster handling package with the desired dimension
   Raster : R.Raster;
   --  the raster itself
   --  we'll write onto one canvas, since that will suffice

begin
   --  first clear it
   Raster.Choose_Pen (R.Colors.White);
   Raster.Clear;
   --  now draw onto it
   --  we will fade blue boxes in (1 * Dimension),
   --  then fade them out (1 * Dimension), giving 2 * Dimension
   for Ith in 1 .. 2 * Dimension loop
      if Ith <= Dimension then   --  fade in
         --  Jth mod 2 = 0 draws every other rectangle
         for Jth in 1 .. Natural'Min (Ith, Dimension / 2) when Jth mod 2 = 0
         loop
            --  this mildly complicated formula fades from outermost rectangle in
            Raster.Choose_Pen
              ((Red | Green => Integer'Max (0, 255 - (Ith - Jth + 1) * Step),
                others => 255));
            Raster.Move_To ((Col => Jth, Row => Jth));
            Raster.Draw_Rectangle_To
              ((Col => Dimension - Jth + 1, Row => Dimension - Jth + 1));
         end loop;
      else  --  fade out
         for Jth in
           1 .. Natural'Min (Ith - Dimension, Dimension / 2) when Jth mod 2 = 0
         loop
            Raster.Choose_Pen
              ((Red | Green =>
                  Integer'Min (255, ((Ith - Dimension) - Jth + 1) * Step),
                others => 255));
            Raster.Move_To ((Col => Jth, Row => Jth));
            Raster.Draw_Rectangle_To
              ((Col => Dimension - Jth + 1, Row => Dimension - Jth + 1));
         end loop;
      end if;
      --  save individual frames to combine into an animation
      declare
         Suffix    : String          := "_0000";
         --  appended to output filenames
         To_Suffix : constant String := Ith'Image;
         --  Ada's 'Image attribute sticks a space before positive numbers alas
         --  that requires us to handle the suffixes a little delicately
      begin
         for Jth in reverse 1 .. To_Suffix'Length loop
            if To_Suffix (Jth) /= ' ' then
               Suffix (Suffix'Length - (To_Suffix'Length - Jth)) :=
                 To_Suffix (Jth);
            end if;
         end loop;
         Raster.Save ("frame" & Suffix & ".ppm", R.PPM);
      end;
   end loop;
end Vibrating_Rectangles;

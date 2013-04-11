with Lumen.Binary;
package body Mandelbrot is
   function Create_Image (Width, Height : Natural) return Lumen.Image.Descriptor is
      use type Lumen.Binary.Byte;
      Result : Lumen.Image.Descriptor;
      X0, Y0 : Float;
      X, Y, Xtemp : Float;
      Iteration   : Float;
      Max_Iteration : constant Float := 1000.0;
      Color : Lumen.Binary.Byte;
   begin
      Result.Width := Width;
      Result.Height := Height;
      Result.Complete := True;
      Result.Values := new Lumen.Image.Pixel_Matrix (1 .. Width, 1 .. Height);
      for Screen_X in 1 .. Width loop
         for Screen_Y in 1 .. Height loop
            X0 := -2.5 + (3.5 / Float (Width) * Float (Screen_X));
            Y0 := -1.0 + (2.0 / Float (Height) * Float (Screen_Y));
            X := 0.0;
            Y := 0.0;
            Iteration := 0.0;
            while X * X + Y * Y <= 4.0 and then Iteration < Max_Iteration loop
               Xtemp := X * X - Y * Y + X0;
               Y := 2.0 * X * Y + Y0;
               X := Xtemp;
               Iteration := Iteration + 1.0;
            end loop;
            if Iteration = Max_Iteration then
               Color := 255;
            else
               Color := 0;
            end if;
            Result.Values (Screen_X, Screen_Y) := (R => Color, G => Color, B => Color, A => 0);
         end loop;
      end loop;
      return Result;
   end Create_Image;

end Mandelbrot;

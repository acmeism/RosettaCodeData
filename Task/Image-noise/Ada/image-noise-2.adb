with Ada.Numerics.Discrete_Random;

package body Noise is
   type Color is (Black, White);
   package Color_Random is new Ada.Numerics.Discrete_Random (Color);
   Color_Gen : Color_Random.Generator;

   function Create_Image (Width, Height : Natural) return Lumen.Image.Descriptor is
      Result : Lumen.Image.Descriptor;
   begin
      Color_Random.Reset (Color_Gen);
      Result.Width := Width;
      Result.Height := Height;
      Result.Complete := True;
      Result.Values := new Lumen.Image.Pixel_Matrix (1 .. Width, 1 .. Height);
      for X in 1 .. Width loop
         for Y in 1 .. Height loop
            if Color_Random.Random (Color_Gen) = Black then
               Result.Values (X, Y) := (R => 0, G => 0, B => 0, A => 0);
            else
               Result.Values (X, Y) := (R => 255, G => 255, B => 255, A => 0);
            end if;
         end loop;
      end loop;
      return Result;
   end Create_Image;

end Noise;

-- FILE: events.adb --
with Cairo;
with GTK;

package body Events is
   function Draw (Self : access GObject_Record'Class;
                  CC   : Cairo.Cairo_Context)
                  return Boolean
   is
      type Rotate_Type is (Counterclockwise, Clockwise);

      type Point is record
         X, Y : GDouble;
      end record;

      procedure Heighway_Branch (CC     : Cairo.Cairo_Context;
                                 A, B   : Point;
                                 Rotate : Rotate_Type;
                                 N      : Natural)
      is
         R, RU, C : Point;
      begin
         if N = 0 then
            Cairo.Move_To (CC, A.X, A.Y);
            Cairo.Line_To (CC, B.X, B.Y);
            Cairo.Stroke (CC);
         else
            -- Rotate 45 degrees --
            case Rotate is
               when Clockwise =>
                  R.X := GDouble ((1.0 / Sqrt (2.0)) * Float (B.X - A.X)
                                   - (1.0 / Sqrt (2.0)) * Float (B.Y - A.Y));
                  R.Y := GDouble ((1.0 / Sqrt (2.0)) * Float (B.X - A.X)
                                   + (1.0 / Sqrt (2.0)) * Float (B.Y - A.Y));
               when Counterclockwise =>
                  R.X := GDouble ((1.0 / Sqrt (2.0)) * Float (B.X - A.X)
                                   + (1.0 / Sqrt (2.0)) * Float (B.Y - A.Y));
                  R.Y := GDouble (-(1.0 / Sqrt (2.0)) * Float (B.X - A.X)
                                   + (1.0 / Sqrt (2.0)) * Float (B.Y - A.Y));
            end case;

            -- Make unit vector from rotation --
            RU.X := GDouble (Float (R.X) / Sqrt ( Float (R.X ** 2 + R.Y ** 2)));
            RU.Y := GDouble (Float (R.Y) / Sqrt ( Float (R.X ** 2 + R.Y ** 2)));

            -- Scale --
            R.X := RU.X * GDouble (Sqrt (Float (B.X - A.X) ** 2 + Float (B.Y - A.Y) ** 2) / Sqrt (2.0));
            R.Y := RU.Y * GDouble (Sqrt (Float (B.X - A.X) ** 2 + Float (B.Y - A.Y) ** 2) / Sqrt (2.0));

            C := (R.X + A.X, R.Y + A.Y);

            Heighway_Branch (CC, A, C, Clockwise, N - 1);
            Heighway_Branch (CC, C, B, Counterclockwise, N - 1);
         end if;
      end Heighway_Branch;

      Depth : constant := 14;
      Center, Right, Bottom, Left: Point;
      Width  : GDouble := GDouble (Drawing_Area.Get_Allocated_Width);
      Height : GDouble := GDouble (Drawing_Area.Get_Allocated_Height);

   begin
      Center := (Width / 2.0, Height / 2.0);
      Right  := (Width,       Height / 2.0);
      Left   := (0.0,         Height / 2.0);
      Bottom := (Width / 2.0, Height);

      Cairo.Set_Source_RGB (CC, 0.0, 1.0, 0.0);
      Heighway_Branch (CC, Center, Right, Clockwise, Depth);
      Cairo.Set_Source_RGB (CC, 0.0, 1.0, 1.0);
      Heighway_Branch (CC, Center, Left, Clockwise, Depth);
      Cairo.Set_Source_RGB (CC, 0.0, 1.0, 0.5);
      Heighway_Branch (CC, Center, Bottom, Clockwise, Depth);

      return True;
   end Draw;
end Events;

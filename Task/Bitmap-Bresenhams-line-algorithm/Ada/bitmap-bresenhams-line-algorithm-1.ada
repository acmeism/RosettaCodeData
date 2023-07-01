procedure Line (Picture : in out Image; Start, Stop : Point; Color : Pixel) is
   DX  : constant Float := abs Float (Stop.X - Start.X);
   DY  : constant Float := abs Float (Stop.Y - Start.Y);
   Err : Float;
   X   : Positive := Start.X;
   Y   : Positive := Start.Y;
   Step_X : Integer := 1;
   Step_Y : Integer := 1;
begin
   if Start.X > Stop.X then
      Step_X := -1;
   end if;
   if Start.Y > Stop.Y then
      Step_Y := -1;
   end if;
   if DX > DY then
      Err := DX / 2.0;
      while X /= Stop.X loop
         Picture (X, Y) := Color;
         Err := Err - DY;
         if Err < 0.0 then
            Y := Y + Step_Y;
            Err := Err + DX;
         end if;
         X := X + Step_X;
      end loop;
   else
      Err := DY / 2.0;
      while Y /= Stop.Y loop
         Picture (X, Y) := Color;
         Err := Err - DX;
         if Err < 0.0 then
            X := X + Step_X;
            Err := Err + DY;
         end if;
         Y := Y + Step_Y;
      end loop;
   end if;
   Picture (X, Y) := Color; -- Ensure dots to be drawn
end Line;

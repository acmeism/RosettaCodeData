procedure Circle
          (  Picture : in out Image;
             Center  : Point;
             Radius  : Natural;
             Color   : Pixel
          )  is
   F     : Integer := 1 - Radius;
   ddF_X : Integer := 0;
   ddF_Y : Integer := -2 * Radius;
   X     : Integer := 0;
   Y     : Integer := Radius;
begin
   Picture (Center.X, Center.Y + Radius) := Color;
   Picture (Center.X, Center.Y - Radius) := Color;
   Picture (Center.X + Radius, Center.Y) := Color;
   Picture (Center.X - Radius, Center.Y) := Color;
   while X < Y loop
      if F >= 0 then
         Y := Y - 1;
         ddF_Y := ddF_Y + 2;
         F := F + ddF_Y;
      end if;
      X := X + 1;
      ddF_X := ddF_X + 2;
      F := F + ddF_X + 1;
      Picture (Center.X + X, Center.Y + Y) := Color;
      Picture (Center.X - X, Center.Y + Y) := Color;
      Picture (Center.X + X, Center.Y - Y) := Color;
      Picture (Center.X - X, Center.Y - Y) := Color;
      Picture (Center.X + Y, Center.Y + X) := Color;
      Picture (Center.X - Y, Center.Y + X) := Color;
      Picture (Center.X + Y, Center.Y - X) := Color;
      Picture (Center.X - Y, Center.Y - X) := Color;
   end loop;
end Circle;

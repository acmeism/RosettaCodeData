procedure Cubic_Bezier
          (  Picture        : in out Image;
             P1, P2, P3, P4 : Point;
             Color          : Pixel;
             N              : Positive := 20
          )  is
   Points : array (0..N) of Point;
begin
   for I in Points'Range loop
      declare
         T : constant Float := Float (I) / Float (N);
         A : constant Float := (1.0 - T)**3;
         B : constant Float := 3.0 * T * (1.0 - T)**2;
         C : constant Float := 3.0 * T**2 * (1.0 - T);
         D : constant Float := T**3;
      begin
         Points (I).X := Positive (A * Float (P1.X) + B * Float (P2.X) + C * Float (P3.X) + D * Float (P4.X));
         Points (I).Y := Positive (A * Float (P1.Y) + B * Float (P2.Y) + C * Float (P3.Y) + D * Float (P4.Y));
      end;
   end loop;
   for I in Points'First..Points'Last - 1 loop
      Line (Picture, Points (I), Points (I + 1), Color);
   end loop;
end Cubic_Bezier;

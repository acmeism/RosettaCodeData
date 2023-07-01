with Ada.Text_IO;
with Pythagorean_Means;
procedure Main is
   My_Set : Pythagorean_Means.Set := (1.0, 2.0, 3.0, 4.0,  5.0,
                                      6.0, 7.0, 8.0, 9.0, 10.0);
   Arithmetic_Mean : Float := Pythagorean_Means.Arithmetic_Mean (My_Set);
   Geometric_Mean  : Float := Pythagorean_Means.Geometric_Mean  (My_Set);
   Harmonic_Mean   : Float := Pythagorean_Means.Harmonic_Mean   (My_Set);
begin
   Ada.Text_IO.Put_Line (Float'Image (Arithmetic_Mean) & " >= " &
                         Float'Image (Geometric_Mean)  & " >= " &
                         Float'Image (Harmonic_Mean));
end Main;

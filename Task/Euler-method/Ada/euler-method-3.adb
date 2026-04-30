with Ada.Text_IO;  use Ada.Text_IO;
with Euler;

procedure Test_Euler_Method is
   package Float_Euler is new Euler (Float);
   use Float_Euler;

   function Newton_Cooling_Law (T, Y : Float) return Float is
   begin
      return -0.07 * (Y - 20.0);
   end Newton_Cooling_Law;

   Y : Waveform := Solve (Newton_Cooling_Law'Access, 100.0, 0.0, 100.0, 10);
begin
   for I in Y'Range loop
      Put_Line (Integer'Image (10 * I) & ":" & Float'Image (Y (I)));
   end loop;
end Test_Euler_Method;

with Ada.Numerics.Complex_Arrays;  use Ada.Numerics.Complex_Arrays;
with Ada.Complex_Text_IO;          use Ada.Complex_Text_IO;
with Ada.Text_IO;                  use Ada.Text_IO;

with Ada.Numerics.Complex_Elementary_Functions;
with Generic_FFT;

procedure Example is
   function FFT is new Generic_FFT (Ada.Numerics.Complex_Arrays);
   X : Complex_Vector := (1..4 => (1.0, 0.0), 5..8 => (0.0, 0.0));
   Y : Complex_Vector := FFT (X);
begin
   Put_Line ("       X              FFT X ");
   for I in Y'Range loop
      Put (X (I - Y'First + X'First), Aft => 3, Exp => 0);
      Put (" ");
      Put (Y (I), Aft => 3, Exp => 0);
      New_Line;
   end loop;
end;

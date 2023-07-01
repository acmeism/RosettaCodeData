with Ada.Text_IO, LCG;

procedure Run_LCGs is

   type M31 is mod 2**31;

   package BSD_Rand is new LCG(Base_Type => M31, Multiplyer => 1103515245,
                               Adder => 12345);

   package MS_Rand  is new LCG(Base_Type => M31, Multiplyer => 214013,
                               Adder => 2531011, Output_Divisor => 2**16);

begin
   for I in 1 .. 10 loop
      Ada.Text_IO.Put_Line(M31'Image(BSD_Rand.Random));
   end loop;
   for I in 1 .. 10 loop
       Ada.Text_IO.Put_Line(M31'Image(MS_Rand.Random));
   end loop;
end Run_LCGs;

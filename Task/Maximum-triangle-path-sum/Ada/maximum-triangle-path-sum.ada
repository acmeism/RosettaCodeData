with Ada.Text_Io; use Ada.Text_Io;

procedure Max_Sum is

   Triangle : array (Positive range <>) of integer :=
                                     (55,
                                    94, 48,
                                  95, 30, 96,
                                77, 71, 26, 67,
                              97, 13, 76, 38, 45,
                            07, 36, 79, 16, 37, 68,
                          48, 07, 09, 18, 70, 26, 06,
                        18, 72, 79, 46, 59, 79, 29, 90,
                      20, 76, 87, 11, 32, 07, 07, 49, 18,
                    27, 83, 58, 35, 71, 11, 25, 57, 29, 85,
                  14, 64, 36, 96, 27, 11, 58, 56, 92, 18, 55,
                02, 90, 03, 60, 48, 49, 41, 46, 33, 36, 47, 23,
              92, 50, 48, 02, 36, 59, 42, 79, 72, 20, 82, 77, 42,
            56, 78, 38, 80, 39, 75, 02, 71, 66, 66, 01, 03, 55, 72,
          44, 25, 67, 84, 71, 67, 11, 61, 40, 57, 58, 89, 40, 56, 36,
        85, 32, 25, 85, 57, 48, 84, 35, 47, 62, 17, 01, 01, 99, 89, 52,
      06, 71, 28, 75, 94, 48, 37, 10, 23, 51, 06, 48, 53, 18, 74, 98, 15,
    27, 02, 92, 23, 08, 71, 76, 84, 15, 52, 92, 63, 81, 10, 44, 10, 69, 93);

   Last  : Integer := Triangle'Length;
   Tn    : Integer := 1;

begin
   while (Tn * (Tn + 1) / 2) < Last  loop
      Tn := Tn + 1;
   end loop;
   for N in reverse 2 .. Tn loop
      for I in 2 .. N loop
	 Triangle (Last - N) := Triangle (Last - N) +
	   Integer'Max(Triangle (Last - 1), Triangle (Last));
	 Last := Last - 1;
      end loop;
      Last := Last - 1;
   end loop;
   Put_Line(Integer'Image(Triangle(1)));
end Max_Sum;

with Ada.Text_IO; use Ada.Text_IO;

procedure Sudan_Function is

   function F (N, X, Y : Natural) return Natural
   is (if    N = 0 then X + Y
       elsif Y = 0 then X
       else  F (N => N - 1,
                X => F (N, X, Y - 1),
                Y => F (N, X, Y - 1) + Y));

begin
   Put_Line ("F0 (0, 0) = " & F (0, 0, 0)'Image);
   Put_Line ("F1 (1, 1) = " & F (1, 1, 1)'Image);
   Put_Line ("F1 (3, 3) = " & F (1, 3, 3)'Image);
   Put_Line ("F2 (1, 1) = " & F (2, 1, 1)'Image);
   Put_Line ("F2 (2, 1) = " & F (2, 2, 1)'Image);
   Put_Line ("F3 (1, 1) = " & F (3, 1, 1)'Image);
end Sudan_Function;

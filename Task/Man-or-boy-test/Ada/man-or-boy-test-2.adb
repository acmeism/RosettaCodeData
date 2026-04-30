with Ada.Text_IO;  use Ada.Text_IO;

procedure Man_Or_Boy is
   function Zero return Integer is (0);
   function One return Integer  is (1);
   function Neg return Integer  is (-1);

   function A
            (K : Integer;
             X1, X2, X3, X4, X5 : access function return Integer)
             return Integer is
      M : Integer := K; -- K is read-only in Ada. Here is a mutable copy of
      function B return Integer is
      begin
         M := M - 1;
         return A (M, B'Access, X1, X2, X3, X4);
      end B;
   begin
      return (if M <= 0 then X4.all + X5.all else B);
   end A;
begin
   Put_Line
     (Integer'Image
        (A (K => 10,
            X1 => One'Access,
            X2 => Neg'Access,
            X3 => Neg'Access,
            X4 => One'Access,
            X5 => Zero'Access)));
end Man_Or_Boy;

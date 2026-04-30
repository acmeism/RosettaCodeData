with Ada.Text_IO, Matrix_Scalar;

procedure Scalar_Ops is

   subtype T is Integer range 1 .. 3;

   package M is new Matrix_Scalar(T, T, Integer);

   -- the functions to solve the task
        function "+" is new M.Func("+");
        function "-" is new M.Func("-");
        function "*" is new M.Func("*");
        function "/" is new M.Func("/");
        function "**" is new M.Func("**");
        function "mod" is new M.Func("mod");

   -- for output purposes, we need a Matrix->String conversion
        function Image is new M.Image(Integer'Image);

   A: M.Matrix := ((1,2,3),(4,5,6),(7,8,9)); -- something to begin with

begin
   Ada.Text_IO.Put_Line("  Initial M=" & Image(A));
   Ada.Text_IO.Put_Line("        M+2=" & Image(A+2));
   Ada.Text_IO.Put_Line("        M-2=" & Image(A-2));
   Ada.Text_IO.Put_Line("        M*2=" & Image(A*2));
   Ada.Text_IO.Put_Line("        M/2=" & Image(A/2));
   Ada.Text_IO.Put_Line("  square(M)=" & Image(A ** 2));
   Ada.Text_IO.Put_Line("    M mod 2=" & Image(A mod 2));
   Ada.Text_IO.Put_Line("(M*2) mod 3=" & Image((A*2) mod 3));
end Scalar_Ops;

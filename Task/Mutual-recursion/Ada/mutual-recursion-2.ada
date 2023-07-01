with Ada.Text_Io; use Ada.Text_Io;
procedure Mutual_Recursion is
   function M(N: Natural) return Natural;
   function F(N: Natural) return Natural;

   function M(N: Natural) return Natural is
       (if N = 0 then 0 else N – F(M(N–1)));

   function F(N: Natural) return Natural is
       (if N =0 then 1 else N – M(F(N–1)));
begin
   for I in 0..19 loop
      Put_Line(Integer'Image(F(I)));
   end loop;
   New_Line;
   for I in 0..19 loop
      Put_Line(Integer'Image(M(I)));
   end loop;

end Mutual_recursion;

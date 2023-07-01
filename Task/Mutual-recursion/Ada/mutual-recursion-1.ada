with Ada.Text_Io; use Ada.Text_Io;
procedure Mutual_Recursion is
   function M(N : Integer) return Integer;
   function F(N : Integer) return Integer is
   begin
      if N = 0 then
         return 1;
      else
         return N - M(F(N - 1));
      end if;
   end F;
   function M(N : Integer) return Integer is
   begin
      if N = 0 then
         return 0;
      else
         return N - F(M(N-1));
      end if;
   end M;
begin
   for I in 0..19 loop
      Put_Line(Integer'Image(F(I)));
   end loop;
   New_Line;
   for I in 0..19 loop
      Put_Line(Integer'Image(M(I)));
   end loop;
end Mutual_recursion;

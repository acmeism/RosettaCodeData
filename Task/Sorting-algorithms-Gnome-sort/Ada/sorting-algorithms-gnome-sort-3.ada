with Gnome_Sort;
with Ada.Text_Io; use Ada.Text_Io;

procedure Gnome_Sort_Test is
   type Index is range 0..9;
   type Buf is array(Index) of Integer;
   procedure Sort is new Gnome_Sort(Integer, Index, Buf);
   A : Buf := (900, 700, 800, 600, 400, 500, 200, 100, 300, 0);
begin
   for I in A'range loop
      Put(Integer'Image(A(I)));
   end loop;
   New_Line;
   Sort(A);
   for I in A'range loop
      Put(Integer'Image(A(I)));
   end loop;
   New_Line;
end Gnome_Sort_Test;

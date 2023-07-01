with Ada.Text_IO; use Ada.Text_IO;

procedure Leonardo is

   function Leo
     (N      : Natural;
      Step   : Natural := 1;
      First  : Natural := 1;
      Second : Natural := 1) return Natural   is
      L : array (0..1) of Natural := (First, Second);
	begin
		for i in 1 .. N loop
			L := (L(1), L(0)+L(1)+Step);
		end loop;
		return L (0);
	end Leo;

begin
   Put_Line ("First 25 Leonardo numbers:");
   for I in 0 .. 24 loop
      Put (Integer'Image (Leo (I)));
   end loop;
   New_Line;
   Put_Line ("First 25 Leonardo numbers with L(0) = 0, L(1) = 1, " &
             "step = 0 (fibonacci numbers):");
   for I in 0 .. 24 loop
      Put (Integer'Image (Leo (I, 0, 0, 1)));
   end loop;
   New_Line;
end Leonardo;

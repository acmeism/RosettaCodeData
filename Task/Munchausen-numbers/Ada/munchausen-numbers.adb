with Ada.Text_IO;

procedure Munchausen is

   function Is_Munchausen (M : in Natural) return Boolean is
      Table : constant array (Character range '0' .. '9') of Natural :=
        (0**0, 1**1, 2**2, 3**3, 4**4,
         5**5, 6**6, 7**7, 8**8, 9**9);
      Image : constant String := M'Image;
      Sum   : Natural := 0;
   begin
      for I in Image'First + 1 .. Image'Last loop
         Sum := Sum + Table (Image (I));
      end loop;
      return Image = Sum'Image;
   end Is_Munchausen;

begin
   for M in 1 .. 5_000 loop
      if Is_Munchausen (M) then
         Ada.Text_IO.Put (M'Image);
      end if;
   end loop;
   Ada.Text_IO.New_Line;
end Munchausen;

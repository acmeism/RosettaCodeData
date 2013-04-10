with Ada.Text_IO;  use Ada.Text_IO;

package body Bitmap_Store is

   procedure Fill (Picture : in out Image; Color : Pixel) is
   begin
      for I in Picture'Range (1) loop
         for J in Picture'Range (2) loop
            Picture (I, J) := Color;
         end loop;
      end loop;
   end Fill;

   procedure Print (Picture : Image) is
   begin
      for I in Picture'Range (1) loop
         for J in Picture'Range (2) loop
            if Picture (I, J) = White then
               Put (' ');
            else
               Put ('H');
            end if;
         end loop;
         New_Line;
      end loop;
   end Print;

end Bitmap_Store;

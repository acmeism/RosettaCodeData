with Ada.Text_IO;
procedure Positives is
begin
   for Value in Positive'Range loop
      Ada.Text_IO.Put_Line (Positive'Image (Value));
   end loop;
end Positives;

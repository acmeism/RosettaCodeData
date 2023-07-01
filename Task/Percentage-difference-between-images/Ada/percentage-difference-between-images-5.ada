   F1, F2 : File_Type;
begin
   Open (F1, In_File, "city.ppm");
   Open (F2, In_File, "city_emboss.ppm");
   Ada.Text_IO.Put_Line ("Diff" & Float'Image (Diff (Get_PPM (F1), Get_PPM (F2))));
   Close (F1);
   Close (F2);

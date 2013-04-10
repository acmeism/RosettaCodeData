declare
   F1, F2 : File_Type;
begin
   Open (F1, In_File, "city.ppm");
   Create (F2, Out_File, "city_grayscale.ppm");
   Put_PPM (F2, Color (Grayscale (Get_PPM (F1))));
   Close (F1);
   Close (F2);
end;

   F1, F2 : File_Type;
begin
   Open (F1, In_File, "city.ppm");
   Create (F2, Out_File, "city_median.ppm");
   Put_PPM (F2, Median (Get_PPM (F1), 1)); -- Window 3x3
   Close (F1);
   Close (F2);

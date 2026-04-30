   F1, F2 : File_Type;
begin
   Open (F1, In_File, "city.ppm");
   declare
      X : Image := Get_PPM (F1);
   begin
      Close (F1);
      Create (F2, Out_File, "city_sharpen.ppm");
      Filter (X, ((-1.0, -1.0, -1.0), (-1.0, 9.0, -1.0), (-1.0, -1.0, -1.0)));
      Put_PPM (F2, X);
   end;
   Close (F2);

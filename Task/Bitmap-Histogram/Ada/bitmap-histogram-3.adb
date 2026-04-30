   F1, F2 : File_Type;
begin
   Open (F1, In_File, "city.ppm");
   declare
      X : Image := Get_PPM (F1);
      Y : Grayscale_Image := Grayscale (X);
      T : Luminance := Median (Get_Histogram (Y));
   begin
      Close (F1);
      Create (F2, Out_File, "city_art.ppm");
      for I in Y'Range (1) loop
         for J in Y'Range (2) loop
            if Y (I, J) < T then
               X (I, J) := Black;
            else
               X (I, J) := White;
            end if;
         end loop;
      end loop;
      Put_PPM (F2, X);
   end;
   Close (F2);

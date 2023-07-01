declare
   File : File_Type;
begin
   Open (File, In_File, "Unfilledcirc.ppm");
   declare
      Picture : Image := Get_PPM (File);
   begin
      Close (File);
      Flood_Fill
      (  Picture  => Picture,
         From     => (122, 30),
         Fill     => (255,0,0),
         Replace  => White
      );
      Create (File, Out_File, "Filledcirc.ppm");
      Put_PPM (File, Picture);
      Close (File);
   end;
end;

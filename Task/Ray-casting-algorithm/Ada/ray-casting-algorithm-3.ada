with Ada.Text_IO;
with Polygons;
procedure Main is
   package Float_IO is new Ada.Text_IO.Float_IO (Float);
   Test_Points : Polygons.Point_List :=
     ((  5.0,  5.0),
      (  5.0,  8.0),
      (-10.0,  5.0),
      (  0.0,  5.0),
      ( 10.0,  5.0),
      (  8.0,  5.0),
      ( 10.0, 10.0));
   Square      : Polygons.Polygon    :=
     ((( 0.0,  0.0), (10.0,  0.0)),
      ((10.0,  0.0), (10.0, 10.0)),
      ((10.0, 10.0), ( 0.0, 10.0)),
      (( 0.0, 10.0), ( 0.0,  0.0)));
   Square_Hole : Polygons.Polygon    :=
     ((( 0.0,  0.0), (10.0,  0.0)),
      ((10.0,  0.0), (10.0, 10.0)),
      ((10.0, 10.0), ( 0.0, 10.0)),
      (( 0.0, 10.0), ( 0.0,  0.0)),
      (( 2.5,  2.5), ( 7.5,  2.5)),
      (( 7.5,  2.5), ( 7.5,  7.5)),
      (( 7.5,  7.5), ( 2.5,  7.5)),
      (( 2.5,  7.5), ( 2.5,  2.5)));
   Strange     : Polygons.Polygon    :=
     ((( 0.0,  0.0), ( 2.5,  2.5)),
      (( 2.5,  2.5), ( 0.0, 10.0)),
      (( 0.0, 10.0), ( 2.5,  7.5)),
      (( 2.5,  7.5), ( 7.5,  7.5)),
      (( 7.5,  7.5), (10.0, 10.0)),
      ((10.0, 10.0), (10.0,  0.0)),
      ((10.0,  0.0), ( 2.5,  2.5)));
   Exagon      : Polygons.Polygon    :=
     ((( 3.0,  0.0), ( 7.0,  0.0)),
      (( 7.0,  0.0), (10.0,  5.0)),
      ((10.0,  5.0), ( 7.0, 10.0)),
      (( 7.0, 10.0), ( 3.0, 10.0)),
      (( 3.0, 10.0), ( 0.0,  5.0)),
      (( 0.0,  5.0), ( 3.0,  0.0)));
begin
   Ada.Text_IO.Put_Line ("Testing Square:");
   for Point in Test_Points'Range loop
      Ada.Text_IO.Put ("Point(");
      Float_IO.Put (Test_Points (Point).X, 0, 0, 0);
      Ada.Text_IO.Put (",");
      Float_IO.Put (Test_Points (Point).Y, 0, 0, 0);
      Ada.Text_IO.Put
        ("): " &
         Boolean'Image (Polygons.Is_Inside (Test_Points (Point), Square)));
      Ada.Text_IO.New_Line;
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Testing Square_Hole:");
   for Point in Test_Points'Range loop
      Ada.Text_IO.Put ("Point(");
      Float_IO.Put (Test_Points (Point).X, 0, 0, 0);
      Ada.Text_IO.Put (",");
      Float_IO.Put (Test_Points (Point).Y, 0, 0, 0);
      Ada.Text_IO.Put
        ("): " &
         Boolean'Image
            (Polygons.Is_Inside (Test_Points (Point), Square_Hole)));
      Ada.Text_IO.New_Line;
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Testing Strange:");
   for Point in Test_Points'Range loop
      Ada.Text_IO.Put ("Point(");
      Float_IO.Put (Test_Points (Point).X, 0, 0, 0);
      Ada.Text_IO.Put (",");
      Float_IO.Put (Test_Points (Point).Y, 0, 0, 0);
      Ada.Text_IO.Put
        ("): " &
         Boolean'Image (Polygons.Is_Inside (Test_Points (Point), Strange)));
      Ada.Text_IO.New_Line;
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Testing Exagon:");
   for Point in Test_Points'Range loop
      Ada.Text_IO.Put ("Point(");
      Float_IO.Put (Test_Points (Point).X, 0, 0, 0);
      Ada.Text_IO.Put (",");
      Float_IO.Put (Test_Points (Point).Y, 0, 0, 0);
      Ada.Text_IO.Put
        ("): " &
         Boolean'Image (Polygons.Is_Inside (Test_Points (Point), Exagon)));
      Ada.Text_IO.New_Line;
   end loop;
end Main;

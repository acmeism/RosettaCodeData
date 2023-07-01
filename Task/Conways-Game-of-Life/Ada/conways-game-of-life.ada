WITH Ada.Text_IO;  USE Ada.Text_IO;

PROCEDURE Life IS
   SUBTYPE Cell IS Natural RANGE 0 .. 1;

   TYPE Petri_Dish IS ARRAY (Positive RANGE <>, Positive RANGE <>) OF Cell;

   PROCEDURE Step (Gen : IN OUT Petri_Dish) IS
      Above       : ARRAY (Gen'Range (2)) OF Cell := (OTHERS => 0);
      Left, This  : Cell;
   BEGIN
      FOR I IN Gen'First (1) + 1 .. Gen'Last (1) - 1 LOOP
         Left := 0;
         FOR J IN Gen'First (2) + 1 .. Gen'Last (2) - 1 LOOP
            This := (CASE Above (J - 1) + Above (J) + Above (J + 1) +
                          Left			    + Gen (I, J + 1) +
                          Gen (I + 1, J - 1) + Gen (I + 1, J) 	+ Gen (I + 1, J + 1) IS
                        WHEN 2      => Gen (I, J),
                        WHEN 3      => 1,
                        WHEN OTHERS => 0);
            Above (J - 1):= Left;
            Left         := Gen (I, J);
            Gen (I, J) 	 := This;
         END LOOP;
         Above (Above'Last - 1) := Left;
      END LOOP;
   END Step;

   PROCEDURE Put (Gen : Petri_Dish) IS
   BEGIN
      FOR I IN Gen'Range (1) LOOP
         FOR J IN Gen'Range (2) LOOP
            Put ( if Gen (I, J) = 0 then " " else "#");
         END LOOP;
         New_Line;
      END LOOP;
   END Put;

   Blinker : Petri_Dish := (2 .. 4 => (0, 0, 1, 0, 0), 1 | 5 => (0, 0, 0, 0, 0));
   Glider  : Petri_Dish (1..6,1..11):= (2 => (3 => 1, others => 0),
                                        3 => (4 => 1, others => 0),
                                        4 => (2|3|4=>1, others => 0),
                                        others => (others => 0));
   PROCEDURE Put_And_Step_Generation (N : Positive; Name : String; P : IN OUT Petri_Dish) IS
   BEGIN
      FOR Generation IN 1 .. N LOOP
         Put_Line (Name & Generation'Img);
         Put (P);
         Step (P);
      END LOOP;
   END Put_And_Step_Generation;

BEGIN
   Put_And_Step_Generation (3, "Blinker", Blinker);
   Put_And_Step_Generation (5, "Glider", Glider);
END Life;

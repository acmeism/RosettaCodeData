WITH Ada.Containers.Generic_Array_Sort, Ada.Text_IO;
USE  Ada.Text_IO;
PROCEDURE Main IS
   TYPE Natural_Array IS ARRAY (Positive RANGE <>) OF Natural;
   FUNCTION Less (L, R : Natural) RETURN Boolean IS (L'Img < R'Img);
   PROCEDURE Sort_Naturals IS NEW Ada.Containers.Generic_Array_Sort
     (Positive, Natural, Natural_Array, Less);
   PROCEDURE Show (Last : Natural) IS
      A : Natural_Array (1 .. Last);
   BEGIN
      FOR I IN A'Range LOOP A (I) := I; END LOOP;
      Sort_Naturals (A);
      FOR I IN  A'Range LOOP Put (A (I)'Img); END LOOP;
      New_Line;
   END Show;
BEGIN
   Show (13);
   Show (21);
END Main;

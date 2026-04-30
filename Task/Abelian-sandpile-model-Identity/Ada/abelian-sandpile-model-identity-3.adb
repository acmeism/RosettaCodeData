with Ada.Text_IO;      use Ada.Text_IO;
with Abelian_Sandpile; use Abelian_Sandpile;

procedure Main is
   sp    : Sandpile := ((4, 3, 3), (3, 1, 2), (0, 2, 3));
   s1    : Sandpile := ((1, 2, 0), (2, 1, 1), (0, 1, 3));
   s2    : Sandpile := ((2, 1, 3), (1, 0, 1), (0, 1, 0));
   s3    : Sandpile := ((3, 3, 3), (3, 3, 3), (3, 3, 3));
   s3_id : Sandpile := ((2, 1, 2), (1, 0, 1), (2, 1, 2));
   sum1  : Sandpile := s1 + s2;
   sum2  : Sandpile := s2 + s1;
   sum3  : Sandpile := s3 + s3_id;
   sum4  : Sandpile := s3_id + s3_id;

begin
   Put_Line ("Avalanche:");
   while not Is_Stable (sp) loop
      Print (sp);
      Put_Line ("stable? " & Boolean'Image (Is_Stable (sp)));
      New_Line;
      Topple (sp);
   end loop;
   Print (sp);
   Put_Line ("stable? " & Boolean'Image (Is_Stable (sp)));
   New_Line;

   Put_Line ("Commutivity:");
   Put_Line ("s1 + s2 equals s2 + s2? " & Boolean'Image (sum1 = sum2));
   New_Line;
   Put_Line ("S1 : s2 =");
   Print (sum1);
   New_Line;
   Put_Line ("s2 + s1 =");
   Print (sum2);
   New_Line;

   Put_Line ("Identity:");
   Put_Line ("s3 + s3_id equals s3? " & Boolean'Image (sum3 = s3));
   Put_Line ("s3_id + s3_id equals s3_id? " & Boolean'Image (sum4 = s3_id));
   New_Line;
   Put_Line ("s3 + s3_id =");
   Print (sum3);
   Put_Line ("s3_id + s3_id =");
   Print (sum4);

end Main;

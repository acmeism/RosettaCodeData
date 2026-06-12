with Ada.Text_IO;  use Ada.Text_IO;
with Quaternions;
procedure Test_Quaternion is
   package Float_Quaternion is new Quaternions (Float);
   use Float_Quaternion;
   q  : Quaternion := (1.0, 2.0, 3.0, 4.0);
   q1 : Quaternion := (2.0, 3.0, 4.0, 5.0);
   q2 : Quaternion := (3.0, 4.0, 5.0, 6.0);
   r  : Float      := 7.0;
begin
   Put_Line ("q = "       & Image (q));
   Put_Line ("q1 = "      & Image (q1));
   Put_Line ("q2 = "      & Image (q2));
   Put_Line ("r ="        & Float'Image (r));
   Put_Line ("abs q ="    & Float'Image (abs q));
   Put_Line ("abs q1 ="   & Float' Image (abs q1));
   Put_Line ("abs q2 ="   & Float' Image (abs q2));
   Put_Line ("-q = "      & Image (-q));
   Put_Line ("conj q = "  & Image (Conj (q)));
   Put_Line ("q1 + q2 = " & Image (q1 + q2));
   Put_Line ("q2 + q1 = " & Image (q2 + q1));
   Put_Line ("q * r = "   & Image (q * r));
   Put_Line ("r * q = "   & Image (r * q));
   Put_Line ("q1 * q2 = " & Image (q1 * q2));
   Put_Line ("q2 * q1 = " & Image (q2 * q1));
end Test_Quaternion;

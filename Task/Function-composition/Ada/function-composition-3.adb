with Ada.Numerics.Elementary_Functions;  use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;                        use Ada.Text_IO;
with Functions;

procedure Test_Compose is
   package Float_Functions is new Functions (Float);
   use Float_Functions;

   Sin_Arcsin : Func := Sin'Access * Arcsin'Access;
begin
   Put_Line (Float'Image (Sin_Arcsin * 0.5));
end Test_Compose;

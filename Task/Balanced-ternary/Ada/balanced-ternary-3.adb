with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with BT; use BT;

procedure TestBT is
   Result, A, B, C : Balanced_Ternary;
begin
   A := To_Balanced_Ternary("+-0++0+");
   B := To_Balanced_Ternary(-436);
   C := To_Balanced_Ternary("+-++-");

   Result := A * (B - C);

   Put("a = "); Put(To_integer(A), 4); New_Line;
   Put("b = "); Put(To_integer(B), 4); New_Line;
   Put("c = "); Put(To_integer(C), 4); New_Line;
   Put("a * (b - c) = "); Put(To_integer(Result), 4);
   Put_Line (" " & To_String(Result));
end TestBT;

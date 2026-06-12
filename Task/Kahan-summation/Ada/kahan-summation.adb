with Ada.Text_Io; use Ada.Text_Io;

procedure Kahan is

   type Kahan_Summer is
      record
         Sum  : Float := 0.0;
         C    : Float := 0.0;
      end record;

   procedure Add (Acc : in out Kahan_Summer; Right : Float) is
      Y : constant Float := Right - Acc.C;
      T : constant Float := Acc.Sum + Y;
   begin
      Acc.C   := (T - Acc.Sum) - Y;
      acc.Sum := T;
   end Add;

   function Sum (Acc : Kahan_Summer) return Float
   is (Acc.Sum);

   function Epsilon return Float is
      E : Float := 1.000;
   begin
      while 1.0 + E /= 1.0 loop
         E := E / 2.0;
      end loop;
      return E;
   end Epsilon;

   A : constant Float := 1.000;
   B : constant Float := Epsilon;
   C : constant Float := -B;
   D : constant Float := (A + B) + C;
   K : Kahan_Summer;

   package Float_Io is new Ada.Text_Io.Float_Io (Float);
   use Float_Io;
begin
   Add (K, A);
   Add (K, B);
   Add (K, C);

   Default_Exp := 0;
   Default_Aft := 12;
   Put ("Epsilon     : "); Put (B); New_Line;
   Put ("(A + B) - C : "); Put (D); New_Line;
   Put ("Kahan sum   : "); Put (Sum (K)); New_Line;
end Kahan;

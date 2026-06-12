with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;

procedure NKTgLaw is

   type NKTg is record
      P         : Float;
      NKTg1     : Float;
      NKTg2     : Float;
      Tendency1 : String (1 .. 32);
      Tendency2 : String (1 .. 33);
   end record;

   function Tendency1 (N : Float) return String is
   begin
      if N > 0.0 then
         return "Moving away from stable state";
      elsif N < 0.0 then
         return "Moving toward stable state";
      else
         return "Stable equilibrium";
      end if;
   end Tendency1;

   function Tendency2 (N : Float) return String is
   begin
      if N > 0.0 then
         return "Mass variation supports movement";
      elsif N < 0.0 then
         return "Mass variation resists movement";
      else
         return "No mass variation effect";
      end if;
   end Tendency2;

   function Compute (X, V, M, Dm_Dt : Float) return NKTg is
      P  : Float := M * V;
      N1 : Float := X * P;
      N2 : Float := Dm_Dt * P;
   begin
      return (
         P         => P,
         NKTg1     => N1,
         NKTg2     => N2,
         Tendency1 => Tendency1(N1),
         Tendency2 => Tendency2(N2)
      );
   end Compute;

   Result : NKTg;

begin
   Result := Compute (2.0, 3.0, 4.0, -0.5);

   Put_Line("{ p = " & Float'Image(Result.P));
   Put_Line("  nktg1 = " & Float'Image(Result.NKTg1));
   Put_Line("  nktg2 = " & Float'Image(Result.NKTg2));
   Put_Line("  tendency1 = """ & Result.Tendency1 & """");
   Put_Line("  tendency2 = """ & Result.Tendency2 & """ }");
end NKTgLaw;

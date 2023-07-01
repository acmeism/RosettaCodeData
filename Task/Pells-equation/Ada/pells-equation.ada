with Ada.Text_Io;
with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Big_Numbers.Big_Integers;

procedure Pells_Equation is
   use Ada.Numerics.Big_Numbers.Big_Integers;

   type Pair is
      record
         V1, V2 : Big_Integer;
      end record;

   procedure Solve_Pell (N : Natural; X, Y : out Big_Integer) is
      use Ada.Numerics.Elementary_Functions;
      Big_N : constant Big_Integer := To_Big_Integer (N);
      XX    : constant Big_Integer := To_Big_Integer (Natural (Float'Floor (Sqrt (Float (N)))));
   begin
      if XX**2 = Big_N then
         X := 1; Y := 0;
         return;
      end if;

      declare
         YY   : Big_Integer := XX;
         Z    : Big_Integer := 1;
         R    : Big_Integer := 2 * XX;
         E    : Pair        := Pair'(V1 => 1, V2 => 0);
         F    : Pair        := Pair'(V1 => 0, V2 => 1);
      begin
         loop
            YY := R * Z - YY;
            Z  := (Big_N - YY**2) / Z;
            R  := (XX + YY) / Z;
            E  := Pair'(V1 => E.V2, V2 => R * E.V2 + E.V1);
            F  := Pair'(V1 => F.V2, V2 => R * F.V2 + F.V1);
            X  := E.V2 + XX * F.V2;
            Y  := F.V2;
            exit when X**2 - Big_N * Y**2 = 1;
         end loop;
      end;
   end Solve_Pell;

   procedure Test (N : Natural) is

      package Natural_Io is new Ada.Text_Io.Integer_Io (Natural);
      use Ada.Text_Io, Natural_Io;

      X, Y : Big_Integer;
   begin
      Solve_Pell (N, X => X, Y => Y);
      Put ("X**2 - ");
      Put (N, Width => 3);
      Put (" * Y**2 = 1 for X = ");
      Put (To_String (X, Width => 22));
      Put (" and Y = ");
      Put (To_String (Y, Width => 20));
      New_Line;
   end Test;

begin
   Test (61);
   Test (109);
   Test (181);
   Test (277);
end Pells_Equation;

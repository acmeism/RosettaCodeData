with Ada.Text_Io;
with Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Strings.Fixed;

procedure Integer_Square_Root is

   use Ada.Numerics.Big_Numbers.Big_Integers;
   use Ada.Text_Io;

   function Isqrt (X : Big_Integer) return Big_Integer is
      Q       : Big_Integer := 1;
      Z, T, R : Big_Integer;
   begin
      while Q <= X loop
         Q := Q * 4;
      end loop;
      Z := X;
      R := 0;
      while Q > 1 loop
         Q := Q / 4;
         T := Z - R - Q;
         R := R / 2;
         if T >= 0 then
            Z := T;
            R := R + Q;
         end if;
      end loop;
      return R;
   end Isqrt;

   function Commatize (N : Big_Integer; Width : Positive) return String is
      S     : constant String := To_String (N, Width);
      Image : String (1 .. Width + Width / 3) := (others => ' ');
      Pos   : Natural := Image'Last;
   begin
      for I in S'Range loop
         Image (Pos) := S (S'Last - I + S'First);
         exit when Image (Pos) = ' ';
         Pos := Pos - 1;
         if I mod 3 = 0 and S (S'Last - I + S'First - 1) /= ' ' then
            Image (Pos) := ''';
            Pos := Pos - 1;
         end if;
      end loop;
      return Image;
   end Commatize;

   type Mode_Kind is (Tens, Ones, Spacer, Result);
begin
   Put_Line ("Integer square roots of integers 0 .. 65:");
   for Mode in Mode_Kind loop
      for N in 0 .. 65 loop
         case Mode is
            when Tens   =>  Put ((if N / 10 = 0
                                  then "  "
                                  else Natural'Image (N / 10)));
            when Ones   =>  Put (Natural'Image (N mod 10));
            when Spacer =>  Put ("--");
            when Result =>  Put (To_String (Isqrt (To_Big_Integer (N))));
         end case;
      end loop;
      New_Line;
   end loop;
   New_Line;

   declare
      package Integer_Io is new Ada.Text_Io.Integer_Io (Natural);
      use Ada.Strings.Fixed;
      N    : Integer    := 1;
      P, R : Big_Integer;
   begin
      Put_Line ("|  N|" & 80 * " " & "7**N|" & 30 * " " & "isqrt (7**N)|");
      Put_Line (133 * "=");
      loop
         P := 7**N;
         R := Isqrt (P);
         Put ("|");  Integer_Io.Put (N, Width => 3);
         Put ("|");  Put (Commatize (P, Width => 63));
         Put ("|");  Put (Commatize (R, Width => 32));
         Put ("|");  New_Line;
         exit when N >= 73;
         N := N + 2;
      end loop;
      Put_Line (133 * "=");
   end;

end Integer_Square_Root;

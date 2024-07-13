pragma Ada_2022;
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers;
use  Ada.Numerics.Big_Numbers.Big_Integers;
with Interfaces;        use Interfaces;

procedure Combs_Perms is

   function U64_Perm (N, K : Unsigned_64) return Unsigned_64 is
      P : Unsigned_64 := 1;
   begin
      if K = 0 then
         P := 0;
      else
         for I in 0 .. K - 1 loop
            P := P * (N - I);
         end loop;
      end if;
      return P;
   end U64_Perm;

   function Big_Perm (N, K : Natural) return Big_Natural is
      P : Big_Natural := 1;
   begin
      if K = 0 then
         P := 0;
      else
         for I in 0 .. K - 1 loop
            P := P * To_Big_Integer (N - I);
         end loop;
      end if;
      return P;
   end Big_Perm;

   function U64_Comb (N, K : Unsigned_64) return Unsigned_64 is
      Adj_K : constant Unsigned_64 := (if N - K < K then N - K else K);
      C : Unsigned_64 := U64_Perm (N, Adj_K);
   begin
      if K = 0 then
         C := 0;
      else
         for I in reverse 1 .. Adj_K loop
            C := C / I;
         end loop;
      end if;
      return C;
   end U64_Comb;

   function Big_Comb (N, K : Natural) return Big_Natural is
      Adj_K : constant Natural := (if N - K < K then N - K else K);
      C : Big_Natural := Big_Perm (N, Adj_K);
   begin
      for I in reverse 1 .. Adj_K loop
         C := C / To_Big_Integer (I);
      end loop;
      return C;
   end Big_Comb;

begin
   Put_Line ("P(1, 0) =" & U64_Perm (1, 0)'Image);
   Put_Line ("P(12, 4) =" & U64_Perm (12, 4)'Image);
   Put_Line ("P(60, 20) =" & U64_Perm (60, 20)'Image);
   Put_Line ("P(105, 103) =" & Big_Perm (105, 103)'Image);
   Put_Line ("P(15000, 333) =" & Big_Perm (10000, 333)'Image);

   Put_Line ("C(10, 5) =" & U64_Comb (10, 5)'Image);
   Put_Line ("C(60, 30) =" & Big_Comb (60, 30)'Image);
   Put_Line ("C(900, 674) =" & Big_Comb (900, 674)'Image);
end Combs_Perms;

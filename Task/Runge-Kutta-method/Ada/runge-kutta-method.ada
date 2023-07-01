with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
procedure RungeKutta is
   type Floaty is digits 15;
   type Floaty_Array is array (Natural range <>) of Floaty;
   package FIO is new Ada.Text_IO.Float_IO(Floaty); use FIO;
   type Derivative is access function(t, y : Floaty) return Floaty;
   package Math is new Ada.Numerics.Generic_Elementary_Functions (Floaty);
   function calc_err (t, calc : Floaty) return Floaty;

   procedure Runge (yp_func : Derivative; t, y : in out Floaty_Array;
                    dt : Floaty) is
      dy1, dy2, dy3, dy4 : Floaty;
   begin
      for n in t'First .. t'Last-1 loop
         dy1 := dt * yp_func(t(n), y(n));
         dy2 := dt * yp_func(t(n) + dt / 2.0, y(n) + dy1 / 2.0);
         dy3 := dt * yp_func(t(n) + dt / 2.0, y(n) + dy2 / 2.0);
         dy4 := dt * yp_func(t(n) + dt, y(n) + dy3);
         t(n+1) := t(n) + dt;
         y(n+1) := y(n) + (dy1 + 2.0 * (dy2 + dy3) + dy4) / 6.0;
      end loop;
   end Runge;

   procedure Print (t, y : Floaty_Array; modnum : Positive) is begin
      for i in t'Range loop
         if i mod modnum = 0 then
            Put("y(");   Put (t(i), Exp=>0, Fore=>0, Aft=>1);
            Put(") = "); Put (y(i), Exp=>0, Fore=>0, Aft=>8);
            Put(" Error:"); Put (calc_err(t(i),y(i)), Aft=>5);
            New_Line;
         end if;
      end loop;
   end Print;

   function yprime (t, y : Floaty) return Floaty is begin
      return t * Math.Sqrt (y);
   end yprime;
   function calc_err (t, calc : Floaty) return Floaty is
      actual : constant Floaty := (t**2 + 4.0)**2 / 16.0;
   begin return abs(actual-calc);
   end calc_err;

   dt : constant Floaty := 0.10;
   N : constant Positive := 100;
   t_arr, y_arr : Floaty_Array(0 .. N);
begin
   t_arr(0) := 0.0;
   y_arr(0) := 1.0;
   Runge (yprime'Access, t_arr, y_arr, dt);
   Print (t_arr, y_arr, 10);
end RungeKutta;

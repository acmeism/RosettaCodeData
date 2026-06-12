with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   subtype double is Long_Float;
   package double_io is new Ada.Text_IO.Float_IO (double);
   use double_io;
   package Elementary_Double is new Ada.Numerics.Generic_Elementary_Functions
     (Float_Type => double);
   use Elementary_Double;

   -- degrees to radians
   Deg : constant := 0.017_453_292_519_943_295_769_236_907_684_886_127_134;

   -- Earth radius in meters
   Re : constant := 6_371_000.0;

   -- integrate in this fraction of the distance already covered
   Dd : constant := 0.001;

   -- integrate only to a height of 10000km. effectively infinity
   Fin : constant := 10_000_000.0;

   function rho (a : double) return double is (Exp (-a / 8_500.0));

   function height (a : double; z : double; d : double) return double is
      aa : double := Re + a;
      hh : double :=
        Sqrt (aa * aa + d * d - 2.0 * d * aa * Cos ((180.0 - z) * Deg));
   begin
      return hh - Re;
   end height;

   function column_density (a : double; z : double) return double is
      sum     : double := 0.0;
      d       : double := 0.0;
      d_delta : double;
   begin
      while d < Fin loop
         -- adaptive step size to avoid it taking forever
         d_delta := Dd * d;
         if d_delta < Dd then
            d_delta := Dd;
         end if;
         sum := sum + rho (height (a, z, d + 0.5 * d_delta)) * d_delta;
         d   := d + d_delta;
      end loop;
      return sum;
   end column_density;

   function air_mass (a : double; z : double) return double is
     (column_density (a, z) / column_density (a, 0.0));

   z : double := 0.0;
begin
   Put_Line ("Angle     0 m              13700 m");
   Put_Line ("------------------------------------");
   while z <= 90.0 loop
      Put(Item => Integer(z), Width => 2);
      Put (Item => air_mass (0.0, z), Fore => 8, Aft => 8, Exp => 0);
      Put (Item => air_mass (13_700.0, z), Fore => 8, Aft => 8, Exp => 0);
      New_Line;
      z := z + 5.0;
   end loop;

end Main;

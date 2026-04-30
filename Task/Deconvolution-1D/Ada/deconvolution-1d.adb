with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   package real_io is new Float_IO (Long_Float);
   use real_io;

   type Vector is array (Natural range <>) of Long_Float;

   function deconv (g, f : Vector) return Vector is
      len : Positive :=
        Integer'Max ((g'Length - f'length), (f'length - g'length));
      h     : Vector (0 .. len);
      Lower : Natural := 0;
   begin
      for n in h'range loop
         h (n) := g (n);
         if n >= f'length then
            Lower := n - f'length + 1;
         end if;
         for i in Lower .. n - 1 loop
            h (n) := h (n) - (h (i) * f (n - i));
         end loop;
         h (n) := h (n) / f (0);
      end loop;
      return h;
   end deconv;

   procedure print (v : Vector) is
   begin
      Put ("(");
      for I in v'range loop
         Put (Item => v (I), Fore => 1, Aft => 1, Exp => 0);
         if I < v'Last then
            Put (" ");
         else
            Put_Line (")");
         end if;
      end loop;
   end print;

   h : Vector := (-8.0, -9.0, -3.0, -1.0, -6.0, 7.0);
   f : Vector :=
     (-3.0, -6.0, -1.0, 8.0, -6.0, 3.0, -1.0, -9.0, -9.0, 3.0, -2.0, 5.0, 2.0,
      -2.0, -7.0, -1.0);
   g : Vector :=
     (24.0, 75.0, 71.0, -34.0, 3.0, 22.0, -45.0, 23.0, 245.0, 25.0, 52.0, 25.0,
      -67.0, -96.0, 96.0, 31.0, 55.0, 36.0, 29.0, -43.0, -7.0);
begin
   print (h);
   print (deconv (g, f));
   print (f);
   print (deconv (g, h));
end Main;

with Ada.Text_IO;

procedure Currency is
   type Dollar is delta 0.01 range 0.0 .. 24_000_000_000_000_000.0;
   package Dollar_IO is new Ada.Text_IO.Fixed_IO(Dollar);

   hamburger_cost : constant := 5.50;
   milkshake_cost : constant := 2.86;
   tax_rate : constant := 0.0765;

   total_cost : constant := hamburger_cost * 4_000_000_000_000_000.0 + milkshake_cost * 2;
   total_tax : constant := total_cost * tax_rate;
   total_with_tax : constant := total_cost + total_tax;
begin
   Ada.Text_IO.Put("Price before tax:");
   Dollar_IO.Put(total_cost);
   Ada.Text_IO.New_Line;

   Ada.Text_IO.Put("Tax:             ");
   Dollar_IO.Put(total_tax);
   Ada.Text_IO.New_Line;

   Ada.Text_IO.Put("Total:           ");
   Dollar_IO.Put(total_with_tax);
   Ada.Text_IO.New_Line;
end Currency;

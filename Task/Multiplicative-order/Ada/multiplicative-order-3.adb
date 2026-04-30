with Ada.Text_IO, Multiplicative_Order;

procedure Main is
   package IIO is new Ada.Text_IO.Integer_IO(Integer);
   use Multiplicative_Order;
begin
   IIO.Put(Find_Order(3,10));
   IIO.Put(Find_Order(37,1000));
   IIO.Put(Find_Order(37,10_000));
   IIO.Put(Find_Order(37, 3343));
   IIO.Put(Find_Order(37, 3344));
   -- IIO.Put(Find_Order( 2,1000));
     --would raise Program_Error, because there is no I with 2**I=1 mod 1000
   Ada.Text_IO.New_Line;
   IIO.Put(Find_Order(3, (2,5)));           --  3 *   5 = 10
   IIO.Put(Find_Order(37, (8, 125)));       --  8 * 125 = 1000
   IIO.Put(Find_Order(37, (16, 625)));      -- 16 * 625 = 10_000
   IIO.Put(Find_Order(37, (1 => 3343)));    -- 1-element-array: 3343 is a prime
   IIO.Put(Find_Order(37, (11, 19, 16)));   -- 11 * 19 * 16 = 3344

   -- this violates the precondition, because 8 and 2 are not coprime
   -- it gives an incorrect result
   IIO.Put(Find_Order(37, (11, 19, 8, 2)));
end Main;

--
-- Determine primality using Wilon's theorem.
-- Uses the approach from Algol W
-- allowing large primes without the use of big numbers.
--
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   type u_64 is mod 2**64;
   package u_64_io is new modular_io (u_64);
   use u_64_io;

   function Is_Prime (n : u_64) return Boolean is
      fact_Mod_n : u_64 := 1;
   begin
      if n < 2 then
         return False;
      end if;
      for i in 2 .. n - 1 loop
         fact_Mod_n := (fact_Mod_n * i) rem n;
      end loop;
      return fact_Mod_n = n - 1;
   end Is_Prime;

   num : u_64 := 1;
   type cols is mod 12;
   count : cols := 0;
begin
   while num < 500 loop
      if Is_Prime (num) then
         if count = 0 then
            New_Line;
         end if;
         Put (Item => num, Width => 6);
         count := count + 1;
      end if;
      num := num + 1;
   end loop;
end Main;

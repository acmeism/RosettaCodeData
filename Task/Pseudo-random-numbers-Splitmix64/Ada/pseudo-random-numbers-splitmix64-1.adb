with Interfaces; use Interfaces;

package Random_Splitmix64 is

   function next_Int return Unsigned_64;
   function next_float return Float;
   procedure Set_State (Seed : in Unsigned_64);
end Random_Splitmix64;

with Interfaces; use Interfaces;

package random_pcg32 is
   function Next_Int return Unsigned_32;
   function Next_Float return Long_Float;
   procedure Seed (seed_state : Unsigned_64; seed_sequence : Unsigned_64);
end random_pcg32;

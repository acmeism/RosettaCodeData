type Long_Number is array (Natural range <>) of Unsigned_32;

function "*" (Left, Right : Long_Number) return Long_Number is
   Result : Long_Number (0..Left'Length + Right'Length - 1) := (others => 0);
   Accum  : Unsigned_64;
begin
   for I in Left'Range loop
      for J in Right'Range loop
         Accum := Unsigned_64 (Left (I)) * Unsigned_64 (Right (J));
         for K in I + J..Result'Last loop
            exit when Accum = 0;
            Accum := Accum + Unsigned_64 (Result (K));
            Result (K) := Unsigned_32 (Accum and 16#FFFF_FFFF#);
            Accum := Accum / 2**32;
         end loop;
      end loop;
   end loop;
   for Index in reverse Result'Range loop -- Normalization
      if Result (Index) /= 0 then
         return Result (0..Index);
      end if;
   end loop;
   return (0 => 0);
end "*";

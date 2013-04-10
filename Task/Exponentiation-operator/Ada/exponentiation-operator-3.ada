package body Integer_Exponentiation is
   --  int^int
   procedure Exponentiate (Argument : in     Integer;
                           Exponent : in     Natural;
                           Result   :    out Integer) is
   begin
      Result := 1;
      for Counter in 1 .. Exponent loop
         Result := Result * Argument;
      end loop;
   end Exponentiate;

   function "**" (Left  : Integer;
                  Right : Natural) return Integer is
      Result : Integer;
   begin
      Exponentiate (Argument => Left,
                    Exponent => Right,
                    Result   => Result);
      return Result;
   end "**";

   --  real^int
   procedure Exponentiate (Argument : in     Float;
                           Exponent : in     Integer;
                           Result   :    out Float) is
   begin
      Result := 1.0;
      if Exponent < 0 then
         for Counter in Exponent .. -1 loop
            Result := Result / Argument;
         end loop;
      else
         for Counter in 1 .. Exponent loop
            Result := Result * Argument;
         end loop;
      end if;
   end Exponentiate;

   function "**" (Left  : Float;
                  Right : Integer) return Float is
      Result : Float;
   begin
       Exponentiate (Argument => Left,
                    Exponent => Right,
                    Result   => Result);
      return Result;
   end "**";
end Integer_Exponentiation;

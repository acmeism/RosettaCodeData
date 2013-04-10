package Integer_Exponentiation is
   --  int^int
   procedure Exponentiate (Argument : in     Integer;
                           Exponent : in     Natural;
                           Result   :    out Integer);
   function "**" (Left  : Integer;
                  Right : Natural) return Integer;

   --  real^int
   procedure Exponentiate (Argument : in     Float;
                           Exponent : in     Integer;
                           Result   :    out Float);
   function "**" (Left  : Float;
                  Right : Integer) return Float;
end Integer_Exponentiation;

generic
   type Real is digits <>;
   with function Sqrt(X: Real) return Real;
   with function "**"(X: Real; Y: Real) return Real;
package Approximation is

   type Number is private;

   -- create an approximation
   function Approx(Value: Real; Sigma: Real) return Number;

   -- unary operations and conversion Real to Number
   function "+"(X: Real) return Number;
   function "-"(X: Real) return Number;
   function "+"(X: Number) return Number;
   function "-"(X: Number) return Number;

   -- addition / subtraction
   function "+"(X: Number; Y: Number) return Number;
   function "-"(X: Number; Y: Number) return Number;

   -- multiplication / division
   function "*"(X: Number; Y: Number) return Number;
   function "/"(X: Number; Y: Number) return Number;

   -- exponentiation
   function "**"(X: Number; Y: Positive) return Number;
   function "**"(X: Number; Y: Real) return Number;

   -- Output to Standard IO (wrapper for Ada.Text_IO and Ada.Text_IO.Float_IO)
   procedure Put_Line(Message: String;
                      Item: Number;
                      Value_Fore: Natural := 7;
                      Sigma_Fore: Natural := 4;
                      Aft:  Natural := 2;
                      Exp:  Natural := 0);
   procedure Put(Item: Number;
                 Value_Fore: Natural := 7;
                 Sigma_Fore: Natural := 3;
                 Aft:  Natural := 2;
                 Exp:  Natural := 0);

private
   type Number is record
      Value: Real;
      Sigma: Real;
   end record;
end Approximation;

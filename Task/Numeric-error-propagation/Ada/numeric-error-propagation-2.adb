with Ada.Text_IO;

package body Approximation is

   package RIO is new Ada.Text_IO.Float_IO(Real);

   -- create an approximation

   function Approx(Value: Real; Sigma: Real) return Number is
   begin
      return (Value, Sigma);
   end Approx;

   -- unary operations and conversion Real to Number

   function "+"(X: Real) return Number is
   begin
      return Approx(X, 0.0);
   end "+";

   function "-"(X: Real) return Number is
   begin
      return Approx(-X, 0.0);
   end "-";

   function "+"(X: Number) return Number is
   begin
      return X;
   end "+";

   function "-"(X: Number) return Number is
   begin
      return Approx(-X.Value, X.Sigma);
   end "-";

   -- addition / subtraction

   function "+"(X: Number; Y: Number) return Number is
      Z: Number;
   begin
      Z.Value := X.Value + Y.Value;
      Z.Sigma := Sqrt(X.Sigma*X.Sigma + Y.Sigma*Y.Sigma);
      return Z;
   end "+";

   function "-"(X: Number; Y: Number) return Number is
   begin
      return X + (-Y);
   end "-";

   -- multiplication / division

   function "*"(X: Number; Y: Number) return Number is
      Z: Number;
   begin
      Z.Value := X.Value * Y.Value;
      Z.Sigma := Z.Value * Sqrt((X.Sigma/X.Value)**2 + (Y.Sigma/Y.Value)**2);
      return Z;
   end "*";

   function "/"(X: Number; Y: Number) return Number is
      Z: Number;
   begin
      Z.Value := X.Value / Y.Value;
      Z.Sigma := Z.Value * Sqrt((X.Sigma/X.Value)**2 + (Y.Sigma/Y.Value)**2);
      return Z;
   end "/";

   -- exponentiation

   function "**"(X: Number; Y: Positive) return Number is
      Z: Number;
   begin
      Z.Value := X.Value ** Y ;
      Z.Sigma := Z.Value * Real(Y) * (X.Sigma/X.Value);
      if Z.Sigma < 0.0 then
         Z.Sigma := - Z.Sigma;
      end if;
      return Z;
   end "**";

   function "**"(X: Number; Y: Real) return Number is
      Z: Number;
   begin
      Z.Value := X.Value ** Y ;
      Z.Sigma := Z.Value * Y * (X.Sigma/X.Value);
      if Z.Sigma < 0.0 then
         Z.Sigma := - Z.Sigma;
      end if;
      return Z;
   end "**";

   -- Output to Standard IO (wrapper for Ada.Text_IO.Float_IO)

   procedure Put_Line(Message: String;
                      Item: Number;
                      Value_Fore: Natural := 7;
                      Sigma_Fore: Natural := 4;
                      Aft:  Natural := 2;
                      Exp:  Natural := 0) is
   begin
      Ada.Text_IO.Put(Message);
      Put(Item, Value_Fore, Sigma_Fore, Aft, Exp);
      Ada.Text_IO.New_Line;
   end Put_Line;

   procedure Put(Item: Number;
                 Value_Fore: Natural := 7;
                 Sigma_Fore: Natural := 3;
                 Aft:  Natural := 2;
                 Exp:  Natural := 0) is
   begin
      RIO.Put(Item.Value, Value_Fore, Aft, Exp);
      Ada.Text_IO.Put(" (+-");
      RIO.Put(Item.Sigma, Sigma_Fore, Aft, Exp);
      Ada.Text_IO.Put(")");
   end Put;

end Approximation;

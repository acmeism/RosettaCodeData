with Ada.Text_IO, Ada.Command_Line, Crypto.Types.Big_Numbers;

procedure Fibonacci is

   X: Positive := Positive'Value(Ada.Command_Line.Argument(1));

   Bit_Length: Positive := 1 + (696 * X) / 1000;
   -- that number of bits is sufficient to store the full result.

   package LN is new Crypto.Types.Big_Numbers
     (Bit_Length + (32 - Bit_Length mod 32));
     -- the actual number of bits has to be a multiple of 32
   use LN;

   function Fib(P: Positive) return Big_Unsigned is
      Previous: Big_Unsigned := Big_Unsigned_Zero;
      Result:   Big_Unsigned := Big_Unsigned_One;
      Tmp:      Big_Unsigned;
   begin
      -- Result = 1 = Fibonacci(1)
      for I in 1 .. P-1 loop
         Tmp := Result;
         Result := Previous + Result;
         Previous := Tmp;
         -- Result = Fibonacci(I+1))
      end loop;
      return Result;
   end Fib;

begin
   Ada.Text_IO.Put("Fibonacci(" & Integer'Image(X) & " ) = ");
   Ada.Text_IO.Put_Line(LN.Utils.To_String(Fib(X)));
end Fibonacci;

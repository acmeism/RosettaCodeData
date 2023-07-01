package Long_Multiplication is
   type Number (<>) is private;

   Zero : constant Number;
   One  : constant Number;

   function Value (Item : in String) return Number;
   function Image (Item : in Number) return String;

   overriding
   function "=" (Left, Right : in Number) return Boolean;

   function "+" (Left, Right : in Number) return Number;
   function "*" (Left, Right : in Number) return Number;

   function Trim (Item : in Number) return Number;
private
   Bits : constant := 16;
   Base : constant := 2 ** Bits;

   type Accumulated_Value is range 0 .. (Base - 1) * Base;
   subtype Digit is Accumulated_Value range 0 .. Base - 1;

   type Number is array (Natural range <>) of Digit;
   for Number'Component_Size use Bits; -- or pragma Pack (Number);

   Zero : constant Number := (1 .. 0 => 0);
   One  : constant Number := (0 => 1);

   procedure Divide (Dividend  : in     Number;
                     Divisor   : in     Digit;
                     Result    :    out Number;
                     Remainder :    out Digit);
end Long_Multiplication;

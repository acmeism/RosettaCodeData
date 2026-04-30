with Generic_Rational;

generic
   with package Rational_Numbers is new Generic_Rational (<>);
package Generic_Taylor_Series is
   use Rational_Numbers;
   type Taylor_Series is array (Natural range <>) of Rational;

   function "+" (A : Taylor_Series) return Taylor_Series;
   function "-" (A : Taylor_Series) return Taylor_Series;

   function "+" (A, B : Taylor_Series) return Taylor_Series;
   function "-" (A, B : Taylor_Series) return Taylor_Series;
   function "*" (A, B : Taylor_Series) return Taylor_Series;

   function Integral (A : Taylor_Series) return Taylor_Series;
   function Differential (A : Taylor_Series) return Taylor_Series;

   function Value (A : Taylor_Series; X : Rational) return Rational;

   Zero : constant Taylor_Series := (0 => Rational_Numbers.Zero);
   One  : constant Taylor_Series := (0 => Rational_Numbers.One);
end Generic_Taylor_Series;

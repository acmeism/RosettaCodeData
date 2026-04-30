with Ada.Numerics.Generic_Complex_Types;
with Ada.Numerics.Generic_Complex_Elementary_Functions;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO.Complex_Io;
with Ada.Text_Io; use Ada.Text_Io;

procedure Factorial_Numeric_Approximation is
   type Real is digits 15;
   package Complex_Pck is new Ada.Numerics.Generic_Complex_Types(Real);
   use Complex_Pck;
   package Complex_Io is new Ada.Text_Io.Complex_Io(Complex_Pck);
   use Complex_IO;
   package Cmplx_Elem_Funcs is new Ada.Numerics.Generic_Complex_Elementary_Functions(Complex_Pck);
   use Cmplx_Elem_Funcs;

   function Gamma(X : Complex) return Complex is
      package Elem_Funcs is new Ada.Numerics.Generic_Elementary_Functions(Real);
      use Elem_Funcs;
      use Ada.Numerics;
      -- Coefficients used by the GNU Scientific Library
      G : Natural := 7;
      P : constant array (Natural range 0..G + 1) of Real := (
         0.99999999999980993, 676.5203681218851, -1259.1392167224028,
         771.32342877765313, -176.61502916214059, 12.507343278686905,
         -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7);
      Z : Complex := X;
      Cx : Complex;
      Ct : Complex;
   begin
      if Re(Z) < 0.5 then
         return Pi / (Sin(Pi * Z) * Gamma(1.0 - Z));
      else
         Z := Z - 1.0;
         Set_Re(Cx, P(0));
         Set_Im(Cx, 0.0);
         for I in 1..P'Last loop
            Cx := Cx + (P(I) / (Z + Real(I)));
         end loop;
         Ct := Z + Real(G) + 0.5;
         return Sqrt(2.0 * Pi) * Ct**(Z + 0.5) * Exp(-Ct) * Cx;
      end if;
   end Gamma;

   function Factorial(N : Complex) return Complex is
   begin
      return Gamma(N + 1.0);
   end Factorial;
   Arg : Complex;
begin
   Put("factorial(-0.5)**2.0 = ");
   Set_Re(Arg, -0.5);
   Set_Im(Arg, 0.0);
   Put(Item => Factorial(Arg) **2.0, Fore => 1, Aft => 8, Exp => 0);
   New_Line;
   for I in 0..9 loop
      Set_Re(Arg, Real(I));
      Set_Im(Arg, 0.0);
      Put("factorial(" & Integer'Image(I) & ") = ");
      Put(Item => Factorial(Arg), Fore => 6, Aft => 8, Exp => 0);
      New_Line;
   end loop;
end Factorial_Numeric_Approximation;

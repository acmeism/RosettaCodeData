with Ada.Text_IO, Crypto.Types.Big_Numbers, Ada.Numerics.Discrete_Random;

procedure Miller_Rabin is

   Bound: constant Positive := 256; -- can be any multiple of 32

   package LN is new Crypto.Types.Big_Numbers (Bound);
   use type LN.Big_Unsigned; -- all computations "mod 2**Bound"

   function "+"(S: String) return LN.Big_Unsigned
     renames LN.Utils.To_Big_Unsigned;

   S: constant String :=
     "4547337172376300111955330758342147474062293202868155909489";
   T: constant String :=
     "4547337172376300111955330758342147474062293202868155909393";

   K: constant Positive := 10;


begin
   Ada.Text_IO.Put_Line("Prime(" & S & ")="
       & Boolean'Image (LN.Mod_Utils.Passed_Miller_Rabin_Test(+S, K)));
   Ada.Text_IO.Put_Line("Prime(" & T & ")="
       & Boolean'Image (LN.Mod_Utils.Passed_Miller_Rabin_Test(+T, K)));
end Miller_Rabin;

--  Big_Numbers is an Ada 2022 unit

with Ada.Numerics.Big_Numbers.Big_Integers,
     Ada.Numerics.Big_Numbers.Big_Reals,
     Ada.Numerics.Generic_Complex_Types,
     Ada.Text_IO;

use Ada.Numerics.Big_Numbers.Big_Integers,
    Ada.Numerics.Big_Numbers.Big_Reals,
    Ada.Text_IO;

procedure Test_Integer is
   --  These are the only numerical types defined in package
   --  "Standard" which is always incuded. 'Base also covers anything
   --  with the same Base types.
   function Is_Integer (N : Integer'Base) return Boolean is (True);
   function Is_Integer (N : Float'Base) return Boolean is (Float'Base'Floor (N) = N);

   --  Additional types defined in the standard library.
   function Is_Integer (N : Big_Integer) return Boolean is (True);

   --  The type says real, but these are rational approximations of
   --  real numbers.
   function Is_Integer (N : Big_Real) return Boolean is (Denominator (N) = 1);

   package Complex_Float is new Ada.Numerics.Generic_Complex_Types (Float);
   use Complex_Float;

   function Is_Integer (N : Complex) return Boolean
     is (Im (N) = 0.0 and then Is_Integer (Re (N)));

   Int_One : Integer := 1;
   Flo_One : Float := 1.0;
   Flo_OneH : Float := 1.5;
   BInt_One : Big_Integer := To_Big_Integer (1);
   BFlo_One : Big_Real := To_Big_Real (1);
   BFlo_OneH : Big_Real := From_String ("1.5");
   CInt_One : Complex := 1.0 + 0.0 * I;
   CInt_OneI : Complex := 1.0 + 1.0 * I;
begin
   Put_Line (Int_One'Image & " is integer? " & Is_Integer (Int_One)'Image);
   Put_Line (Flo_One'Image & " is integer? " & Is_Integer (Flo_One)'Image);
   Put_Line (Flo_OneH'Image & " is integer? " & Is_Integer (Flo_OneH)'Image);
   Put_Line (BInt_One'Image & " is integer? " & Is_Integer (BInt_One)'Image);
   Put_Line (BFlo_One'Image & " is integer? " & Is_Integer (BFlo_One)'Image);
   Put_Line (BFlo_OneH'Image & " is integer? " & Is_Integer (BFlo_OneH)'Image);
   Put_Line (CInt_One'Image & " is integer? " & Is_Integer (CInt_One)'Image);
   Put_Line (CInt_OneI'Image & " is integer? " & Is_Integer (CInt_OneI)'Image);
end Test_Integer;

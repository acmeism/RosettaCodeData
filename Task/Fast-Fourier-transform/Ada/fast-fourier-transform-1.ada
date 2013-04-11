with Ada.Numerics.Generic_Complex_Arrays;

generic
   with package Complex_Arrays is
      new Ada.Numerics.Generic_Complex_Arrays (<>);
   use Complex_Arrays;
function Generic_FFT (X : Complex_Vector) return Complex_Vector;

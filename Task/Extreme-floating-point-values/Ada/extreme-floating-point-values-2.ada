with Ada.Text_IO; use Ada.Text_IO;

procedure IEEE is -- Non portable, bad, never do this!
   Zero  : Float := 0.0;
   PInf  : Float := 1.0 / Zero;
   NInf  : Float := -PInf;
   PZero : Float := 1.0 / PInf;
   NZero : Float := 1.0 / NInf;
   NaN   : Float := 0.0 / Zero;
begin
   Put_Line (" -oo = " & Float'Image (NInf));
   Put_Line (" +oo = " & Float'Image (PInf));
   Put_Line (" NaN = " & Float'Image (NaN));
   Put_Line ("  -0 = " & Float'Image (NZero));

   Put_Line (" -oo < first " & Boolean'Image (NInf < Float'First));
   Put_Line (" +oo > last  " & Boolean'Image (PInf > Float'Last));
   Put_Line (" NaN = NaN   " & Boolean'Image (NaN = NaN));
   Put_Line ("  -0 = 0     " & Boolean'Image (NZero = 0.0));
   Put_Line ("  +0 = 0     " & Boolean'Image (PZero = 0.0));
   Put_Line ("  +0 < least positive   " & Boolean'Image (PZero < Float'Succ (Zero)));
   Put_Line ("  -0 > biggest negative " & Boolean'Image (NZero > Float'Pred (Zero)));

      -- Validness checks
   Put_Line ("Valid -oo is " & Boolean'Image (NInf'Valid));
   Put_Line ("Valid +oo is " & Boolean'Image (PInf'Valid));
   Put_Line ("Valid NaN is " & Boolean'Image (NaN'Valid));

end IEEE;

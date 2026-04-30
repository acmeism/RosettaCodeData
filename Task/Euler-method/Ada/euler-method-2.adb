package body Euler is
   function Solve
            (  F      : not null access function (T, Y : Number) return Number;
               Y0     : Number;
               T0, T1 : Number;
               N      : Positive
            )  return Waveform is
      dT : constant Number := (T1 - T0) / Number (N);
   begin
      return Y : Waveform (0..N) do
         Y (0) := Y0;
         for I in 1..Y'Last loop
            Y (I) := Y (I - 1) + dT * F (T0 + dT * Number (I - 1), Y (I - 1));
         end loop;
      end return;
   end Solve;
end Euler;

generic
   type Number is digits <>;
package Euler is
   type Waveform is array (Integer range <>) of Number;
   function Solve
            (  F      : not null access function (T, Y : Number) return Number;
               Y0     : Number;
               T0, T1 : Number;
               N      : Positive
            )  return Waveform;
end Euler;

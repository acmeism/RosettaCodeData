Select[Table[M = 2^p - 1;
  For[i = 1; s = 4, i <= p - 2, i++, s = Mod[s^2 - 2, M]];
  If[s == 0, "M" <> ToString@p, p], {p,
   Prime /@ Range[300]}], StringQ]

=> {M3, M5, M7, M13, M17, M19, M31, M61, M89, M107, M127, M521, M607, M1279}

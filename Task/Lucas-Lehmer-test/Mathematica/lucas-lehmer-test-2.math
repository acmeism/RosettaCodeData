t = SessionTime[];
For[p = 2, True, p = NextPrime[p], M = 2^p - 1;
 For[i = 1; s = 4, i <= p - 2, i++, s = Mod[s^2 - 2, M]];
 If[s == 0, Print["M" <> ToString@p]]]
(SessionTime[] - t) {Seconds, Minutes/60, Hours/3600, Days/86400}

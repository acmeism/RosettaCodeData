PROC ℒ next random = (REF ℒ INT a)ℒ REAL: ( a :=
¢ the next pseudo-random ℒ integral value after 'a' from a
uniformly distributed sequence on the interval [ℒ 0,ℒ maxint] ¢;

¢ the real value corresponding to 'a' according to some mapping of
integral values [ℒ 0, ℒ max int] into real values [ℒ 0, ℒ 1)
i.e. such that -0 <= x < 1 such that the sequence of real
values so produced preserves the properties of pseudo-randomness
and uniform distribution of the sequence of integral values ¢);

INT ℒ last random := # some initial random number #;
PROC ℒ random = ℒ REAL: ℒ next random(ℒ last random);

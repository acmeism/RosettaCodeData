MODE ℵ SIMPLEOUT = UNION (≮ℒ INT≯, ≮ℒ REAL≯, ≮ℒ COMPL≯, BOOL, ≮ℒ BITS≯, CHAR, [ ] CHAR);
PROC ℓ cos = (ℒ REAL x) ℒ REAL: ¢ a ℒ real value close to the cosine of 'x' ¢;

PROC ℓ complex cos = (ℒ COMPL z) ℒ COMPL: ¢ a ℒ complex value close to the cosine of 'z' ¢;

PROC ℓ arccos = (ℒ REAL x) ℒ REAL: ¢ if ABS x ≤ ℒ 1, a ℒ real value close
      to the inverse cosine of 'x', ℒ 0 ≤ ℒ arccos (x) ≤ ℒ pi ¢;

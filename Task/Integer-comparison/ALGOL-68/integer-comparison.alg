main: (
  INT a, b;
  read((a, space, b, new line));

  IF a <= b OR a LE b # OR a ≤ b # THEN
    print((a," is less or equal to ", b, new line))
  FI;
  IF a < b OR a LT b THEN
    print((a," is less than ", b, new line))
  ELIF a = b OR a EQ b THEN
    print((a," is equal to ", b, new line))
  ELIF a > b OR a GT b THEN
    print((a," is greater than ", b, new line))
  FI;
  IF a /= b OR a NE b # OR a ≠ b # THEN
    print((a," is not equal to ", b, new line))
  FI;
  IF a >= b OR a GE b # OR a ≥ b # THEN
    print((a," is greater or equal to ", b, new line))
  FI
)

MODE XYZ = STRUCT(INT x,y,z);

OP +:= = (REF FLEX[]XYZ lhs, XYZ rhs)FLEX[]XYZ: (
  [UPB lhs+1]XYZ out;
  out[:UPB lhs] := lhs;
  out[UPB out] := rhs;
  lhs := out
);

INT n = 20;
print (([]XYZ(
  FLEX[0]XYZ xyz;
  FOR x TO n DO FOR y FROM x+1 TO n DO FOR z FROM y+1 TO n DO IF x*x + y*y = z*z THEN xyz +:= XYZ(x,y,z) FI OD OD OD;
  xyz), new line
))

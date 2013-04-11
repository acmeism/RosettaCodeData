# GAP has built-in support for quaternions

A := QuaternionAlgebra(Rationals);
# <algebra-with-one of dimension 4 over Rationals>

b := BasisVectors(Basis(A));
# [ e, i, j, k ]

q := [1, 2, 3, 4]*b;
# e+(2)*i+(3)*j+(4)*k

# Computing norm may be difficult, since the result would be in a quadratic field (Sqrt exists in GAP, is quite unusual, see ?E in GAP, and the following example
Sqrt(5/3);
# 1/3*E(60)^7+1/3*E(60)^11-1/3*E(60)^19-1/3*E(60)^23-1/3*E(60)^31+1/3*E(60)^43-1/3*E(60)^47+1/3*E(60)^59

q1 := [2, 3, 4, 5]*b;
# (2)*e+(3)*i+(4)*j+(5)*k

q2 := [3, 4, 5, 6]*b;
# (3)*e+(4)*i+(5)*j+(6)*k

q1*q2 - q2*q1;
# (-2)*i+(4)*j+(-2)*k

# Can't add directly to a rational, one must make a quaternion of it
r:=5/3*b[1];
# (5/3)*e
r + q;
# (8/3)*e+(2)*i+(3)*j+(4)*k

# For multiplication, no problem (we are in an algebra over rationals !)
r * q;
# (5/3)*e+(10/3)*i+(5)*j+(20/3)*k
5/3 * q;
# (5/3)*e+(10/3)*i+(5)*j+(20/3)*k

# Negative
-q;
(-1)*e+(-2)*i+(-3)*j+(-4)*k

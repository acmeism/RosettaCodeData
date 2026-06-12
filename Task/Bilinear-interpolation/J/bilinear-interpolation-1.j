Note 'FEA'
   Here we develop a general method to generate isoparametric interpolants.

   The interpolant is the dot product of the four shape function values evaluated
   at the coordinates within the element with the known values at the nodes.
   The sum of four shape functions of two variables (xi, eta) is 1 at each of four nodes.
   Let the base element have nodal coordinates (xi, eta) of +/-1.


    2               3 (1,1)
   +---------------+
   |               |
   |               |
   |        (0,0)  |
   |       *       |
   |               |
   |               |
   |               |
   +---------------+
    0               1

   determine f0(xi,eta), ..., f3(xi,eta).
   f0(-1,-1) = 1, f0(all other corners) is 0.
   f1( 1,-1) = 1, f1(all other corners) is 0.
   ...

   Choose a shape function.
   Use shape functions C0 + C1*xi + C2*eta + C3*xi*eta .
   Given (xi,eta) as the vector y form a vector of the
   coefficients of the constants (1, xi, eta, and their product)

      shape_function =: 1 , {. , {: , */

      CORNERS NB. are the ordered coordinates of the corners
   _1 _1
    1 _1
   _1  1
    1  1

      (=i.4)  NB. rows of the identity matrix are the values of each shape functions at each corner
   1 0 0 0
   0 1 0 0
   0 0 1 0
   0 0 0 1

      (=i.4x) %. shape_function"1 x: CORNERS  NB. Compute the values of the constants as rational numbers.
    1r4  1r4  1r4 1r4
   _1r4  1r4 _1r4 1r4
   _1r4 _1r4  1r4 1r4
    1r4 _1r4 _1r4 1r4

   This method extends to higher order interpolants having more nodes or to other dimensions.
)

mp =: +/ .*  NB. matrix product

CORNERS =: 21 A.-.+:#:i.4
shape_function =: 1 , ] , */
COEFFICIENTS =: (=i.4) %. shape_function"1 CORNERS
shape_functions =: COEFFICIENTS mp~ shape_function
interpolate =: mp shape_functions

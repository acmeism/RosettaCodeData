Note 'plan, Working in complex plane'
  Make an equilateral triangle.
  Make a list of N targets
  Starting with a random point near the triangle,
    iteratively generate new points.
  plot the new points.

  j has a particularly rich notation for numbers.

    1ad_90 specifies a complex number with radius 1
    at an angle of negative 90 degrees.

    2p1 is 2 times (pi raised to the first power).
)

N=: 3000

require'plot'
TAU=: 2p1 NB. tauday.com
mean=: +/ % #

NB. equilateral triangle with vertices on unit circle
NB. rotated for fun.
TRIANGLE=: *(j./2 1 o.(TAU%6)*?0)*1ad_90 1ad150 1ad30

TARGETS=: (N ?@:# 3) { TRIANGLE

NB. start on unit circle
START=: j./2 1 o.TAU*?0

NEW_POINTS=: (mean@:(, {.) , ])/ TARGETS , START

'marker'plot NEW_POINTS

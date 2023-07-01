#!/bin/sh

# Using the optimizer, even at low settings, avoids trampolines and
# executable stacks.
gfortran -std=f2018 -g -O1 xiaolin_wu_line_algorithm.f90

./a.out > alpha.pgm
ppmpat -anticamo -randomseed=36 1000 750 | pambrighten -value=-60 -saturation=50 > fg.pam
ppmpat -poles -randomseed=57 1000 750 | pambrighten -value=+200 -saturation=-80 > bg.pam
pamcomp -alpha=alpha.pgm fg.pam bg.pam | pamtopng > image.png

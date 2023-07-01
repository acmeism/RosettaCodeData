#!/usr/local/bin/a68g --script #
############################
# some simple test cases:  #
############################

MODE SCALAR = INT;
PR READ "Template_Range_extraction_Iterative.a68" PR
#PR READ "Template_Range_extraction_Generative.a68" PR#
MODE RANGEINT = UNIRANGE;

test: BEGIN
  []INT int list = ( # unnormalised #
    0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
    37, 38, 39);

  []RANGE range list = ( # unnormalised #
    (0,0),  (1,1),  (2,2),  (4,4),  (6,6),  (7,7),  (8,8), (11,11), (12,12), (14,14),
    (15,15), (16,16), (17,17), (18,18), (19,19), (20,20), (21,21), (22,22), (23,23), (24,24),
    (25,25), (27,27), (28,28), (29,29), (30,30), (31,31), (32,32), (33,33), (35,35), (36,36),
    (37,37), (38,38), (39,39));

  []RANGEINT list a = ( # unnormalised #
    RANGE(0,2), 4, RANGE(6,8), RANGE(11,12),
    RANGE(14,25), RANGE(27,33), RANGE(35,39));

  []RANGEINT list b = ( # unnormalised #
    0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
    37, 38, 39);

  []RANGEINT list c = INITUNIRANGE(list b); # normalised #

# compare manipulation of various types of argument lists #
  printf(($gl$,
    REPR INITUNIRANGE int list,
    REPR INITUNIRANGE range list,
    REPR INITUNIRANGE list a,
    REPR INITUNIRANGE list b,
    REPR list c
  ))
END

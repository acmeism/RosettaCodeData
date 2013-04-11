rfd=: 1r180p1&*                                          NB. convert angle to radians from degrees
toComplex=: *.inv                                        NB. maps integer pairs as length, complex angle (in radians)
mean=: +/ % #                                            NB. calculate arithmetic mean
roundComplex=: (* * |)&.+.                               NB. discard an extraneous least significant bit of precision from a complex value whose magnitude is in the vicinity of 1
avgAngleR=: _1 { [: roundComplex@mean&.toComplex 1 ,. ]  NB. calculate average angle in radians
avgAngleD=: avgAngleR&.rfd

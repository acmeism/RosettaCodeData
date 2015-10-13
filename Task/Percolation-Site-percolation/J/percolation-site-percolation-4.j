any =: +./
all =: *./

quickCheck =: [: all [: (any"1) 2 *./\ ] NB. a complete path requires connections between all row pairs

percolate =: 15 15&$: : (dyad define) NB. returns 0 iff blocked   Use: (N, M) percolate P
 NB. make a binary grid
 GRID =: y (> ?@($&0)) x

 NB. compute the return value
 if. -. quickCheck GRID do. 0 return. end.
 STARTING_SITES =. 0 ,. ({. GRID) # i. {: x NB. indexes of 1 in head row of GRID
 any STARTING_SITES check GRID
)


NB. use local copy of GRID.  Too slow.
check =: dyad define"1 2 NB. return 1 iff through path found  use: START check GRID
 GRID =. y
 LOCATION =. x
 if. 0 (= #) LOCATION do. 0 return. end. NB. no starting point?  0
 if. LOCATION any@:((>: , 0 > [) $) GRID do. 0 return. end. NB. off grid?  0
 INDEX =. <LOCATION
 if. 1 ~: INDEX { GRID do. 0 return. end. NB. fail.  either already looked here or non-path
 if. (>: {. LOCATION) = (# GRID) do. 1 return. end. NB. Success!  (display GRID here)
 G =: GRID =. INDEX (>:@:{)`[`]}GRID
 any GRID check~ LOCATION +"1 (, -)0 1,:1 0
)

NB. use global GRID.
check =: dyad define"1 2 NB. return 1 iff through path found  use: START check GRID
 LOCATION =. x
 if. 0 (= #) LOCATION do. 0 return. end. NB. no starting point?  0
 if. LOCATION any@:((>: , 0 > [) $) GRID do. 0 return. end. NB. off grid?  0
 INDEX =. <LOCATION
 if. 1 ~: INDEX { GRID do. 0 return. end. NB. fail.  either already looked here or non-path
 if. (>: {. LOCATION) = (# GRID) do. 1 return. end. NB. Success!  (display GRID here)
 GRID =: INDEX (>:@:{)`[`]}GRID
 any GRID check~ LOCATION +"1 (, -)0 1,:1 0
)

simulate =: 100&$: : ([ %~ [: +/ [: percolate"0 #) NB. return fraction of connected cases.  Use: T simulate P

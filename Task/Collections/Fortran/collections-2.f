 TYPE(MIXED)           !Name the "type".
  INTEGER COUNTER        !Its content is listed.
  REAL WEIGHT,DEPTH
  CHARACTER*28 MARKNAME
  COMPLEX PATH(6)        !The mixed collection includes an array.
 END TYPE MIXED
 TYPE(MIXED) TEMP,A(6) !Declare some items of that type.

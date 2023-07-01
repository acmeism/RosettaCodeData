   digits      =: ,.&.":
   polymult    =: +//.@(*/)
   buildDecimal=: 10x&#.

   longmult=: buildDecimal@polymult&digits

/*REXX doesn't have declarations/allocations of variables, */
/*     but this is the closest to an allocation:           */

stemmed_array.= 0    /*any undefined element will have this value. */

stemmed_array.1    = '1st entry'
stemmed_array.2    = '2nd entry'
stemmed_array.6000 = 12 ** 2
stemmed_array.dog  = stemmed_array.6000 / 2

drop stemmed_array.

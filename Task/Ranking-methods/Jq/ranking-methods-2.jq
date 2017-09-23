def raw:
 [
 "Solomon",  44,
 "Jason"  ,  42,
 "Errol"  ,  42,
 "Garry"  ,  41,
 "Bernard",  41,
 "Barry"  ,  41,
 "Stephen",  39
] ;

def task:
 "standard:   \( raw | standard_ranking)",
 "modified:   \( raw | modified_ranking)",
 "dense:      \( raw | dense_ranking)",
 "ordinal:    \( raw | ordinal_ranking)",
 "fractional: \( raw | fractional_ranking)" ;

task

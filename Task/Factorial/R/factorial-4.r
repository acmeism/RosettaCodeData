 fact_fp <- function(n) ifelse(!n, 1, Reduce(`*`, seq_len(n)))

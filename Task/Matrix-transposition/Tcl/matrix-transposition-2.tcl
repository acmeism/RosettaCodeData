package require struct::matrix
struct::matrix M
M deserialize {5 4 {{1 1 1 1} {2 4 8 16} {3 9 27 81} {4 16 64 256} {5 25 125 625}}}
M format 2string
M transpose
M format 2string

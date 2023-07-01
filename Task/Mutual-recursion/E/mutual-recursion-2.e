def M
def  F(n) { return if (n <=> 0) { 1 } else { n - M(F(n - 1)) } }
bind M(n) { return if (n <=> 0) { 0 } else { n - F(M(n - 1)) } }

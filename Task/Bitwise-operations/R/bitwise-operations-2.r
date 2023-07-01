a <- as.hexmode(35)
b <- as.hexmode(42)
as.integer(a & b)      # 34
as.integer(a | b)      # 43
as.integer(xor(a, b))  # 9

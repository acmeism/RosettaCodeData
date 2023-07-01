var exprs = [-4294967295, 3000000000 + 3000000000, 2147483647 - 4294967295, 65537 * 65537]
System.print("Unsigned 32-bit:")
for (expr in exprs) System.print(expr >> 0)

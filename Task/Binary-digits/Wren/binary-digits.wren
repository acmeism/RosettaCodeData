import "./fmt" for Fmt

System.print("Converting to binary:")
for (i in [5, 50, 9000]) Fmt.print("$d -> $b", i, i)

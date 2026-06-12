import "./fmt" for Fmt

System.print("Cumulative sums of the first 50 cubes:")
var sum = 0
for (n in 0..49) {
    sum = sum + n * n * n
    Fmt.write("$,9d ", sum)
    if ((n % 10) == 9) System.print()
}
System.print()

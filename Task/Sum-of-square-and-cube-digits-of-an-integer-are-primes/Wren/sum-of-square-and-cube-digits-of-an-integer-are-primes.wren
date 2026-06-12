import "./math" for Int

for (i in 1..99) {
    if (Int.isPrime(Int.digitSum(i*i)) && Int.isPrime(Int.digitSum(i*i*i))) System.write("%(i) ")
}
System.print()

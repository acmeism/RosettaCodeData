println("Numbers > 1 that can be written as the sum of fifth powers of their digits:")
arr = [i for i in 2 : 9^5 * 6 if mapreduce(x -> x^5, +, digits(i)) == i]
println(join(arr, " + "), " = ", sum(arr))

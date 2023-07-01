def fib0to20 = (0..20).collect(fib)
println fib0to20

try {
    println fib(-25)
} catch (Throwable e) {
    println "KABOOM!!"
    println e.message
}

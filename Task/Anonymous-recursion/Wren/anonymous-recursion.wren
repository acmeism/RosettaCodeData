class Fibonacci {
    static compute(n) {
        var fib
        fib = Fn.new {|n|
            if (n < 2) return n
            return fib.call(n - 1) + fib.call(n - 2)
        }

        if (n < 0) return null
        return fib.call(n)
    }
}

System.print(Fibonacci.compute(36))

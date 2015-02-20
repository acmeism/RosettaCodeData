fun fib n =
    let
        fun fib 0 = 0
          | fib 1 = 1
          | fib n = fib (n-1) + fib (n-2)
    in
        if n < 0 then
            raise Fail "Negative"
        else
            fib n
    end

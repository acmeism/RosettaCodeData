fun fix f x = f (fix f) x

fun fib n =
    if n < 0 then raise Fail "Negative"
    else
        fix (fn fib =>
                (fn 0 => 0
                | 1 => 1
                | n => fib (n-1) + fib (n-2))) n

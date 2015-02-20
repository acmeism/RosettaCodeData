((main
    {{iter fib !}
    20 times

    collect !
    rev

    {%d " " . <<}
    each})

(collect { -1 take })

(fib
  {{dup 2 <}
        {fnord}
        {dup
            <- 2 - fib ! ->
            1 - fib !
            + }
    ifte}))

((main {
    (2 3 5 7 11 13 17 19 23)
    avg !
    %d nl <<})

(avg {
    dup
    <- sum ! ->
    len
    cudiv })

(sum { <- 0 -> {+} each }))

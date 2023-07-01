((main { 10 star_triangle ! })

(star_triangle {
    dup
    <-
    { dup { "*" << } <->
            iter - 1 +
        times
        "\n" << }
    ->
    times }))

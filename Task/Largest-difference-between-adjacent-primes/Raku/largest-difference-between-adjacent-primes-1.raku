for 2..8 -> $n {
    printf "Largest prime gap up to {10 ** $n}: %d - between %d and %d.\n", .[0], |.[1]
      given max (^10**$n).grep(&is-prime).rotor(2=>-1).map({.[1]-.[0],$_})
}

((irregular ("st" "nd" "rd"))

(main
    {(0 250 1000)
    { test ! "\n" << }
    each})

(test {
    <-
    {iter 1 - -> dup <- + ordinalify ! <<
        {iter 10 %} {"  "} {"\n"} ifte << }
    26 times})

(ordinalify {
    <-
    {{ -> dup <- 100 % 10 cugt } !
     { -> dup <- 100 % 14 cult } !
     and not
     { -> dup <- 10  % 0  cugt } !
     { -> dup <- 10  % 4  cult } !
     and
     and}
        { -> dup
            <- %d "'"
            irregular -> 10 % 1 - ith
            . . }
        { -> %d "'th" . }
    ifte }))

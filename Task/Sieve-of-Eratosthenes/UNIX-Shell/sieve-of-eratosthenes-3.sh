sourc() {
    seq 2 1000
}

cull() {
    while
        read p || exit
    do
        (($p % $1 != 0)) && echo $p
    done
}

sink() {
    read p || exit
    echo $p
    cull $p | sink &
}

sourc | sink

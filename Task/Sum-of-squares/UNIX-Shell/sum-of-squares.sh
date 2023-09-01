sum_squares () {
        _r=0
        for _n
        do
                : "$((_r += _n * _n))"
        done
        echo "$_r"
}

sum_squares 3 1 4 1 5 9

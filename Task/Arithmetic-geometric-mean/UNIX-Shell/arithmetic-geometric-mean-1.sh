function agm {
    float a=$1 g=$2 eps=${3:-1e-11} tmp
    while (( abs(a-g) > eps )); do
        print "debug: a=$a\tg=$g"
        tmp=$(( (a+g)/2.0 ))
        g=$(( sqrt(a*g) ))
        a=$tmp
    done
    echo $a
}

agm $((1/sqrt(2))) 1

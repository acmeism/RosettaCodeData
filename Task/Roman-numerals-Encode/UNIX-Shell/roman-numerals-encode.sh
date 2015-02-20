roman() {
    local values=( 1000 900 500 400 100 90 50 40 10 5 4 1 )
    local roman=(
        [1000]=M [900]=CM [500]=D [400]=CD
         [100]=C  [90]=XC  [50]=L  [40]=XL
          [10]=X   [9]=IX   [5]=V   [4]=IV
           [1]=I
    )
    local nvmber=""
    local num=$1
    for value in ${values[@]}; do
        while (( num >= value )); do
            nvmber+=${roman[value]}
            ((num -= value))
        done
    done
    echo $nvmber
}

for test in 1999 24 944 1666 2008; do
    printf "%d = %s\n" $test $(roman $test)
done

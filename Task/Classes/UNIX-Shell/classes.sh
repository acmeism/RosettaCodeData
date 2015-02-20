typeset -T Summation_t=(
    integer sum

    # the constructor
    function create {
        _.sum=0
    }

    # a method
    function add {
        (( _.sum += $1 ))
    }
)

Summation_t s
for i in 1 2 3 4 5; do
    s.add $i
done
print ${s.sum}

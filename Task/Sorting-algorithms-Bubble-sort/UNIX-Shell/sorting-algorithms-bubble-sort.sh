$ function bubble_sort() {
    local a=("$@")
    local n
    local i
    local j
    local t
    ft=(false true)
    n=${#a[@]} # array length
    i=n
    while ${ft[$(( 0 < i ))]}
    do
        j=0
        while ${ft[$(( j+1 < i ))]}
        do
            if ${ft[$(( a[j+1] < a[j] ))]}
            then
    	        t=${a[j+1]}
    	        a[j+1]=${a[j]}
    	        a[j]=$t
    	    fi
            t=$(( ++j ))
        done
        t=$(( --i ))
    done
    echo ${a[@]}
}

> > > > > > > > > > > > > > > > > > > > > > > > > $ # this line output from bash
$ bubble_sort 3 2 8
2 3 8
$ # create an array variable
$ a=(2 45 83 89 1 82 69 88 112 99 0 82 58 65 782 74 -31 104 4 2)
$ bubble_sort ${a[@]}
-31 0 1 2 2 4 45 58 65 69 74 82 82 83 88 89 99 104 112 782
$ b=($( bubble_sort ${a[@]} ) )
$ echo ${#b[@]}
20
$ echo ${b[@]}
-31 0 1 2 2 4 45 58 65 69 74 82 82 83 88 89 99 104 112 782
$

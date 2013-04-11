halve()
{
    expr "$1" / 2
}

double()
{
    expr "$1" \* 2
}

is_even()
{
    expr "$1" % 2 = 0 >/dev/null
}

ethiopicmult()
{
    plier=$1
    plicand=$2
    r=0
    while [ "$plier" -ge 1 ]; do
	is_even "$plier" || r=`expr $r + "$plicand"`
	plier=`halve "$plier"`
	plicand=`double "$plicand"`
    done
    echo $r
}

ethiopicmult 17 34
# => 578

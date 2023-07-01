#
# RossetaCode: Sum to 100, AWK.
#
# Find solutions to the "sum to one hundred" puzzle.

function evaluate(code)
{
    value  = 0
    number = 0
    power  = 1
    for ( k = 9; k >= 1; k-- )
    {
        number = power*k + number
        op = code % 3
        if ( op == 0 ) {
            value = value + number
            number = 0
            power = 1
        } else if (op == 1 ) {
            value = value - number
            number = 0
            power = 1
        } else if ( op == 2) {
            power = power * 10
        } else {
        }
        code = int(code / 3);
    }
    return value;
}

function show(code)
{
    s = ""
    a = 19683
    b = 6561

    for ( k = 1; k <= 9; k++ )
    {
        op = int( (code % a) / b )
        if ( op == 0 && k > 1 )
            s = s "+"
        else if ( op == 1 )
            s = s "-"
        else {
        }
        a = b
        b = int(b / 3)
        s = s  k
    }
    printf "%9d = %s\n", evaluate(code), s;
}


BEGIN {
    nexpr = 13122

    print
    print "Show all solutions that sum to 100"
    print
    for ( i = 0; i < nexpr; i++ ) if ( evaluate(i) == 100 ) show(i);

    print
    print "Show the sum that has the maximum number of solutions"
    print
    for ( i = 0; i < nexpr; i++ ) {
        sum = evaluate(i);
        if ( sum >= 0 )
            stat[sum]++;
    }
    best = (-1);
    for ( sum in stat )
        if ( best < stat[sum] ) {
            best = stat[sum]
            bestSum = sum
        }
    delete stat
    printf "%d has %d solutions\n", bestSum, best

    print
    print "Show the lowest positive number that can't be expressed"
    print
    for ( i = 0; i <= 123456789; i++ ){
        for ( j = 0; j < nexpr; j++ )
            if ( i == evaluate(j) )
                break;
        if ( i != evaluate(j) )
            break;
    }
    printf "%d\n",i

    print
    print "Show the ten highest numbers that can be expressed"
    print
    limit = 123456789 + 1;
    for ( i = 1; i <= 10; i++ )
    {
        best = 0;
        for ( j = 0; j < nexpr; j++ )
        {
            test = evaluate(j);
            if ( test < limit && test > best ) best = test;
        }
        for ( j = 0; j < nexpr; j++ ) if ( evaluate(j) == best ) show(j)
        limit = best
    }
}

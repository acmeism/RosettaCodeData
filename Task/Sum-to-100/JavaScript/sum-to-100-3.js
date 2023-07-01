SumTo100();

function SumTo100()
{
    var
        ADD  = 0,
        SUB  = 1,
        JOIN = 2;

    var
        nexpr = 13122;

    function out(something)
    {
        WScript.Echo(something);
    }

    function evaluate(code)
    {
        var
            value  = 0,
            number = 0,
            power  = 1;

        for ( var k = 9; k >= 1; k-- )
        {
            number = power*k + number;
            switch( code % 3 )
            {
                case ADD:  value = value + number; number = 0; power = 1; break;
                case SUB:  value = value - number; number = 0; power = 1; break;
                case JOIN: power = power * 10                           ; break;
            }
            code = Math.floor(code/3);
        }
        return value;
    }

    function print(code)
    {
        var
            s = "";
        var
            a = 19683,
            b = 6561;

        for ( var k = 1; k <= 9; k++ )
        {
            switch( Math.floor(  (code % a) / b  ) ){
                case ADD: if ( k > 1 ) s = s + '+'; break;
                case SUB:              s = s + '-'; break;
            }
            a = b;
            b = Math.floor(b/3);
            s = s + String.fromCharCode(0x30+k);
        }
        out(evaluate(code) + " = " + s);
    }

    function comment(commentString)
    {
        out("");
        out(commentString);
        out("");
    }

    comment("Show all solutions that sum to 100");
    for ( var i = 0; i < nexpr; i++)
        if ( evaluate(i) == 100 )
            print(i);

    comment("Show the sum that has the maximum number of solutions");
    var stat = {};
    for ( var i = 0; i < nexpr; i++ )
    {
        var sum = evaluate(i);
        if (stat[sum])
            stat[sum]++;
        else
            stat[sum] = 1;
    }

    var best = 0;
    var nbest = -1;
    for ( var i = 0; i < nexpr; i++ )
    {
        var sum = evaluate(i);
        if ( sum > 0 )
            if ( stat[sum] > nbest )
            {
                best = i;
                nbest = stat[sum];
            }
    }
    out("" + evaluate(best) + " has " + nbest + " solutions");

    comment("Show the lowest positive number that can't be expressed");
    for ( var i = 0; i <= 123456789; i++ )
    {
        for ( var j = 0; j < nexpr; j++)
            if ( i == evaluate(j) ) break;
        if ( i != evaluate(j) ) break;
    }
    out(i);

    comment("Show the ten highest numbers that can be expressed");
    var limit = 123456789 + 1;
    for ( i = 1; i <= 10; i++ )
    {
        var best = 0;
        for ( var j = 0; j < nexpr; j++)
        {
            var test = evaluate(j);
            if ( test < limit && test > best )
                best = test;
        }
        for ( var j = 0; j < nexpr; j++)
            if ( evaluate(j) == best ) print(j);
        limit = best;
    }

}

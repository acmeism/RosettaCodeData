# usage:  awk -f fizzbuzzGen.awk > fizzbuzzCustom.awk
#
function Print(s) {
    print s > "/dev/stderr"
}

BEGIN { Print( "# FizzBuzz-Generate:" )
        q2 = "\""
        fN = "numbers.txt"
       #fP = "fizzbuzzCustom.awk"
}

NF==1 { Print( "# " $1 " Numbers:" )
        for( i=1; i <= $1; i++ )
            print( i ) > fN   # (!!) write to file not allowed in sandbox at ideone.com

        Print( "# Custom program:" )
        print "BEGIN {print " q2 "# CustomFizzBuzz:" q2 "} \n"
        next
}

NF==2 { Print( "# " $1 "-->" $2 )   ##
        print "$1 %  "$1" == 0 {x = x "q2 $2 q2 "}"
        next
}

END {  print ""
       print "!x  {print $1; next}"
       print "    {print " q2 " " q2 ", x; x=" q2 q2 "} \n"

       print "END {print " q2 "# Done." q2 "}"
       Print( "# Done." )
}

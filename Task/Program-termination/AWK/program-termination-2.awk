# usage:  awk -f exittest.awk input.txt
BEGIN  { print "# Exit-Test" }

#/s.*t/ { print "!", NR, $0; next }           #1: List all matches
 /s.*t/ { print "!", NR, $0; problem=1; exit} #2: Abort after first match
        { print " ", NR, $0}

END     { if(problem) {print "!! Problem !!"; exit 2} }
END     { print "# Lines read:", NR }

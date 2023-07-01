$2=="OUT" {
    count = count + 1
    time = $4
    if ( count > maxcount ) {
        maxcount = count
        maxtimes = time
    } else {
        if ( count == maxcount ) {
            maxtimes = maxtimes " and " time
        }
    }
}
$2=="IN" { count = count - 1 }
END {print "The biggest number of licenses is " maxcount " at " maxtimes " !"}

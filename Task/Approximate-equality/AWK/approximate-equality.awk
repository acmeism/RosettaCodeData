# syntax: GAWK -f APPROXIMATE_EQUALITY.AWK
# converted from C#
BEGIN {
    epsilon = 1
    while (1 + epsilon != 1) {
      epsilon /= 2
    }
    printf("epsilon = %18.16g\n\n",epsilon)
    main("100000000000000.01","100000000000000.011")
    main("100.01","100.011")
    main("10000000000000.001"/"10000.0","1000000000.0000001000")
    main("0.001","0.0010000001")
    main("0.000000000000000000000101","0.0")
    main(sqrt(2.0)*sqrt(2.0),"2.0")
    main(-sqrt(2.0)*sqrt(2.0),"-2.0")
    main("3.14159265358979323846","3.14159265358979324")
    exit(0)
}
function main(a,b,  tmp) {
    tmp = abs(a - b) < epsilon
    printf("%d %27s %s\n",tmp,a,b)
}
function abs(x) { if (x >= 0) { return x } else { return -x } }

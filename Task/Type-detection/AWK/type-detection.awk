# syntax: TAWK -f TYPE_DETECTION.AWK
# uses Thompson Automation's TAWK 5.0c
BEGIN {
    arr[0] = 0
    print(typeof(arr))
    print(typeof(0.))
    print(typeof(0))
    print(typeof(/0/))
    print(typeof("0"))
    print(typeof(x))
    print(typeof(addressof("x")))
    print(typeof(fopen("x","r")))
    exit(0)
}

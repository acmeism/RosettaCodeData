# syntax: GAWK -f WHAT_WEEKDAYS_WILL_CHRISTMAS_AND_NEW_YEAR.AWK
BEGIN {
    fmt = "%Y-%m-%d is a %A"
    print(strftime(fmt,mktime("2021 12 25 0 0 0")))
    print(strftime(fmt,mktime("2022 01 01 0 0 0")))
    print("")
    fmt = "%d %b %Y is %A"
    print(strftime(fmt,mktime("2021 12 25 0 0 0")))
    print(strftime(fmt,mktime("2022 01 01 0 0 0")))
    exit(0)
}

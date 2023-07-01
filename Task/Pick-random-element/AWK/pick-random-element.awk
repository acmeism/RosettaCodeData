# syntax: GAWK -f PICK_RANDOM_ELEMENT.AWK
BEGIN {
    n = split("Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday",day_of_week,",")
    srand()
    x = int(n*rand()) + 1
    printf("%s\n",day_of_week[x])
    exit(0)
}

BEGIN {
    weight[1] = "red"; weight[2] = "white"; weight[3] = "blue";
    # ballnr must be >= 3. Using very high numbers here may make your computer
    # run out of RAM. (10 millions balls ~= 2.5GiB RAM on x86_64)
    ballnr = 10

    srand()
    # Generating a random pool of balls. This python-like loop is actually
    # a prettyfied one-liner
    do
        for (i = 1; i <= ballnr; i++)
            do
                balls[i] = int(3 * rand() + 1)
            # These conditions ensure the 3 first balls contains
            # a white, blue and red ball. Removing 'i < 4' would
            # hit performance a lot.
            while ( (i < 4 && i > 1 && balls[i] == balls[i - 1]) ||
                    (i < 4 && i > 2 && balls[i] == balls[i - 2]) )
    while (is_dnf(balls, ballnr))

    printf("BEFORE: ")
    print_balls(balls, ballnr, weight)

    # Using gawk default quicksort. Using variants of PROCINFO["sorted_in"]
    # wasn't faster than a simple call to asort().
    asort(balls)

    printf("\n\nAFTER : ")
    print_balls(balls, ballnr, weight)

    sorting = is_dnf(balls, ballnr) ? "valid" : "invalid"
    print("\n\nSorting is " sorting ".")
}

function print_balls(balls, ballnr, weight      ,i) {
    for (i = 1; i <= ballnr; i++)
        printf("%-7s", weight[balls[i]])
}

function is_dnf(balls, ballnr) {
    # Checking if the balls are sorted in the Dutch national flag order,
    # using a simple scan with weight comparison
    for (i = 2; i <= ballnr; i++)
        if (balls[i - 1] > balls[i])
            return 0
    return 1
}

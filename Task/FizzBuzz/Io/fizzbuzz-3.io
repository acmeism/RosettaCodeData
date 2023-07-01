for (n, 1, 100,
    fb := list (
        if (n % 3 == 0, "Fizz"),
        if (n % 5 == 0, "Buzz")) select (isTrue)

    if (fb isEmpty, n, fb join) println
)

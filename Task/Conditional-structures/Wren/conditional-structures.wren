for (b in [true, false]) {
    if (b) {
        System.print(true)
    } else {
        System.print(false)
    }

    // equivalent code using ternary operator
    System.print(b ? true : false)

    // equivalent code using && operator
    System.print(b && true)

    // equivalent code using || operator
    System.print(b || false)

    System.print()
}

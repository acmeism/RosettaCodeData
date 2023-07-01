def checkLuhn(number) {
    int total
    (number as String).reverse().eachWithIndex { ch, index ->
        def digit = Integer.parseInt(ch)
        total += (index % 2 ==0) ? digit : [0, 2, 4, 6, 8, 1, 3, 5, 7, 9][digit]
    }
    total % 10 == 0
}

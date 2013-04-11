def luhnTest(number: String): Boolean = {
    var odd = true
    var sum = 0

    for (int <- number.reverse.map{ i => i.toString.toInt }) {
        if (odd)
            sum = sum + int
        else
            sum = sum + (int * 2 % 10) + (int / 5)

        odd = !odd
    }

    sum % 10 == 0
}

println(luhnTest("49927398716"))
println(luhnTest("49927398717"))
println(luhnTest("1234567812345678"))
println(luhnTest("1234567812345670"))

class ChurchNumerals {
    static void main(args) {

        def zero = { f -> { a -> a } }
        def succ = { n -> { f -> { a -> f(n(f)(a)) } } }
        def add = { n -> { k -> { n(succ)(k) } } }
        def mult = { f -> { g -> { a -> f(g(a)) } } }
        def pow = { f -> { g -> g(f) } }

        def toChurchNum
        toChurchNum = { n ->
            n == 0 ? zero : succ(toChurchNum(n - 1))
        }

        def toInt = { n ->
            n(x -> x + 1)(0)
        }

        def three = succ(succ(succ(zero)))
        println toInt(three) // prints 3

        def four = succ(three)
        println toInt(four) // prints 4

        println "3 + 4 = ${toInt(add(three)(four))}" // prints 3 + 4 = 7
        println "4 + 3 = ${toInt(add(four)(three))}" // prints 4 + 3 = 7

        println "3 * 4 = ${toInt(mult(three)(four))}" // prints 3 * 4 = 12
        println "4 * 3 = ${toInt(mult(four)(three))}" // prints 4 * 3 = 12

        println "3 ^ 4 = ${toInt(pow(three)(four))}" // prints 3 ^ 4 = 81
        println "4 ^ 3 = ${toInt(pow(four)(three))}" // prints 4 ^ 3 = 64
    }
}

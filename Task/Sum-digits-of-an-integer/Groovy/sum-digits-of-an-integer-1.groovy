def digitsum = { number, radix = 10 ->
    Integer.toString(number, radix).collect { Integer.parseInt(it, radix) }.sum()
}

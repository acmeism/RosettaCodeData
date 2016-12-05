func factorial(num: Int) -> Int {

    return num < 1 ? 1 : num * factorial(num - 1)
}

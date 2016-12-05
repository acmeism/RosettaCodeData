func factorial(num: Int) -> Int {

    return num < 1 ? 1 : reduce(1...num, 1, *)
}

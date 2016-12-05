class Arithmetic {
    static mean(arr) {
        if (arr.count == 0) Fiber.abort("Length must be greater than zero")
        return arr.reduce(Fn.new{ |x,y| x+y }) / arr.count
    }
}
Arithmetic.mean([1,2,3,4,5]) // 3

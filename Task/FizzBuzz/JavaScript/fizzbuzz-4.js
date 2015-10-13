(function rng(i) {
    return i ? rng(i - 1).concat(i) : []
})(100).map(
    function (n) {
        return n % 3 ? (
            n % 5 ? n : "Buzz"
        ) : (
            n % 5 ? "Fizz" : "FizzBuzz"
        )
    }
).join(' ')

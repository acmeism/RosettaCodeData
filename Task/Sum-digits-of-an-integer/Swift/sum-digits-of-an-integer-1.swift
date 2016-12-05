let number = 1234
let base   = 10

println(number.toString(base: base).characters
    .map { char in String(char).toInt(base: 10) }
    .reduce(0, combine: +))

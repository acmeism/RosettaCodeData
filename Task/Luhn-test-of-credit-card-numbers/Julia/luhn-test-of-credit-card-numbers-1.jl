luhntest(x::Integer) = (sum(digits(x)[1:2:end]) + sum(map(x -> sum(digits(x)), 2 * digits(x)[2:2:end]))) % 10 == 0

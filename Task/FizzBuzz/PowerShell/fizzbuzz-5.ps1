filter fizz-buzz{
    @(
        $_,
        "Fizz",
        "Buzz",
        "FizzBuzz"
    )[
        2 *
        ($_ -match '[05]$') +
        ($_ -match '(^([369][0369]?|[258][147]|[147][258]))$')
    ]
}

1..100 | fizz-buzz

for ($i = 1; $i -le 100; $i++) {
    if ($i % 15 -eq 0) {
        "FizzBuzz"
    } elseif ($i % 5 -eq 0) {
        "Buzz"
    } elseif ($i % 3 -eq 0) {
        "Fizz"
    } else {
        $i
    }
}

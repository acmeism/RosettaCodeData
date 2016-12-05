shared void run() {
    value numbers = "49927398716
                     49927398717
                     1234567812345678
                     1234567812345670";
    for(number in numbers.lines) {
        print("``number`` passes? ``luhn(number)``");
    }
}

shared Boolean luhn(String number) {
    value digits = number
        .reversed
        .map(Character.string)
        .map(parseInteger)
        .coalesced;
    value s1 = sum {0, *digits.by(2)};
    value s2 = sum {
      0,
      *digits
        .skip(1)
        .by(2)
        .map(curry(times<Integer>)(2))
        .map((Integer element) => element / 10 + element % 10)
    };
    return (s1 + s2) % 10 == 0;
}

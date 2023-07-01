# Usage: GAWK -f BULLS_AND_COWS.AWK
BEGIN {
    srand()
    secret = ""
    for (i = 1; i <= 4; ) {
        digit = int(9 * rand()) + 1
        if (index(secret, digit) == 0) {
            secret = secret digit
            i++
        }
    }
    print "Welcome to 'Bulls and Cows'!"
    print "I thought of a 4-digit number."
    print "Please enter your guess."
}
iswellformed($0) {
    if (calcscore($0, secret)) {
        exit
    }
}
function iswellformed(number,    i, digit) {
    if (number !~ /[1-9][1-9][1-9][1-9]/) {
        print "Your guess should contain 4 digits, each from 1 to 9. Try again!"
        return 0
    }
    for (i = 1; i <= 3; i++) {
        digit = substr(number, 1, 1)
        number = substr(number, 2)
        if (index(number, digit) != 0) {
            print "Your guess contains a digit twice. Try again!"
            return 0
        }
    }
    return 1
}
function calcscore(guess, secret,    bulls, cows, i, idx) {
    # Bulls = correct digits at the right position
    # Cows = correct digits at the wrong position
    for (i = 1; i <= 4; i++) {
        idx = index(secret, substr(guess, i, 1))
        if (idx == i) {
            bulls++
        } else if (idx > 0) {
            cows++
        }
    }
    printf("Your score for this guess: Bulls = %d, Cows = %d.", bulls, cows)
    if (bulls < 4) {
        printf(" Try again!\n")
    } else {
        printf("\nCongratulations, you win!\n")
    }
    return bulls == 4
}

module bulls_and_cows;
import std::io;
import std::math::random;

const MAXNUM = 9877;

fn uint get_digit(uint num, uint ps)
{
    while (ps-- > 0) {
        num /= 10;
    }
    return num % 10;
}

fn bool is_malformed(uint num)
{
    if (num >= MAXNUM) {
        return true;
    }
    for (uint i = 0; i <= 2; i++) {
        for (uint j = i + 1; j <= 3; j++) {
            if (get_digit(num, j) == get_digit(num, i)) {
                return true;
            }
        }
    }
    return false;
}

fn uint make_number()
{
    uint num;
    do {
        num = random::rand(MAXNUM);
    } while (is_malformed(num));
    return num;
}

fn uint? input()
{
    String line = io::treadline()!;
    uint num;
    foreach (ch : line) {
        if (!ch.is_digit()) {
            break;
        }
        num *= 10;
        num += ch - '0';
    }
    return num;
}

fn void main()
{
    io::printn("Welcome to bulls and cows!\n"
           "\n"
           "I choose a number made of 4 digits (from 0 to 9) without repetitions.\n"
           "You enter a number of 4 digits, and I say you how many of them\n"
           "are in my secret number but in wrong position (cows),\n"
           "and how many are in the right position (bulls).\n");

    uint secret = make_number();
    uint count, guess;
    while (guess != secret) {
        count++;
        do {
            io::printn("Guess a number.");
            if (try reply = input()) {
                guess = reply;
            } else {
                return;
            }
        } while (is_malformed(guess));

        uint cows, bulls;
        for (uint i = 0; i <= 3; i++) {
            for (uint j = 0; j <= 3; j++) {
                if (get_digit(secret, i) == get_digit(guess, j)) {
                    if (i == j) {
                        bulls++;
                    } else {
                        cows++;
                    }
                }
            }
        }
        io::printfn("You scored %d bulls and %d cows.\n", bulls, cows);
    }
    io::printfn("Correct. That took you %d guesses.", count);
}

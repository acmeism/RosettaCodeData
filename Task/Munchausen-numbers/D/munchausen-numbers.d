import std.stdio;

void main() {
    for (int i=1; i<5000; i++) {
        // loop through each digit in i
        // e.g. for 1000 we get 0, 0, 0, 1.
        int sum = 0;
        for (int number=i; number>0; number/=10) {
            int digit = number % 10;
            // find the sum of the digits
            // raised to themselves
            sum += digit ^^ digit;
        }
        if (sum == i) {
            // the sum is equal to the number
            // itself; thus it is a
            // munchausen number
            writeln(i);
        }
    }
}

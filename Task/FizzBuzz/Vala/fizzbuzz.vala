int main() {
    for (int i = 1; i <= 100; i++) {
        if (i % 3 == 0) stdout.printf("Fizz\n");
        if (i % 5 == 0) stdout.printf("Buzz\n");
        if (i % 15 == 0) stdout.printf("FizzBuzz\n");
        if (i % 3 != 0 && i % 5 != 0) stdout.printf("%d\n", i);

    }
return 0;;
}

int main() {
        int guess, x = Random.int_range(1, 10);
        stdout.printf("Make a guess (1-10): ");
        while((guess = int.parse(stdin.read_line())) != x) {
                stdout.printf("%s! Try again: ", x < guess ? "Lower" : "Higher");
        }
        stdout.printf("Got it!\n");
        return 0;
}

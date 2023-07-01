int main (string[] args) {
    for (var i = 1; i <= 5; i++) {
        for (var j = 1; j <= i; j++) {
	    stdout.putc ('*');
        }
        stdout.putc ('\n');
    }
    return 0;
}

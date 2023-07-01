Using GLib;

int main (string[] args) {
    stdout.printf ("Please enter int value for A\n");
    var a = int.parse (stdin.read_line ());
    stdout.printf ("Please enter int value for B\n");
    var b = int.parse (stdin.read_line ());
    stdout.printf ("A + B = %d\n", a + b);
    return 0;
}

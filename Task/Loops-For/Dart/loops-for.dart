import 'dart:io';
main() {
    for (var i = 0; i < 5; i++) {
        for (var j = 0; j < i + 1; j++)
            stdout.write("*");
        print("");
    }
}

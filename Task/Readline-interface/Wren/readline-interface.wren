import "io" for Stdin, Stdout

class ReadLine {
    static start {
        __hist = []
        System.print("Enter a command, type help for a listing.")
        while (true) {
            System.write(">")
            Stdout.flush()
            var cmd = Stdin.readLine().trim()
            if (cmd == "exit") {
                return
            } else if (cmd == "hello") {
                hello_
            } else if (cmd == "hist") {
                hist_
            } else if (cmd == "help") {
                help_
            } else {
                System.print("Unknown command, try again")
            }
        }
    }

    static hello_ {
        System.print("Hello World!")
        __hist.add("hello")
    }

    static hist_ {
        if (__hist.count == 0) {
            System.print("No history")
        } else {
            for (cmd in __hist) System.print("  - %(cmd)")
        }
        __hist.add("hist")
    }

    static help_ {
        System.print("Available commands:")
        System.print("  hello")
        System.print("  hist")
        System.print("  exit")
        System.print("  help")
        __hist.add("help")
    }
}

ReadLine.start

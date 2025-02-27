import "io" for Stdout, Stderr

System.print("Is output device a terminal?")
System.print("  stdout: %(Stdout.isTerminal)")
System.print("  stderr: %(Stderr.isTerminal)")

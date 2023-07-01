import "io" for Stdin

System.print("Input device is a terminal? %(Stdin.isTerminal ? "Yes" : "No")")

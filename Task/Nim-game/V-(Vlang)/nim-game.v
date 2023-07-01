import os { input }

fn show_tokens(tokens int) {
    println('Tokens remaining $tokens\n')
}

fn main() {
    mut tokens := 12
    for {
        show_tokens(tokens)
        t := input('  How many tokens 1, 2, or 3? ').int()
        if t !in [1, 2, 3] {
            println('\nMust be a number between 1 and 3, try again.\n')
        } else {
            ct := 4 - t
            mut s := 's'
            if ct == 1 {
                s = ''
            }
            println('  Computer takes $ct token$s \n')
            tokens -= 4
        }
        if tokens == 0 {
            show_tokens(0)
            println('  Computer wins!')
            return
        }
    }
}

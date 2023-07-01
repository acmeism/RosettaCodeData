PicoLisp sets the value of the variable (symbol) '@' to the result of
conditional and controlling expressions in flow- and logic-functions (cond, if,
and, when, while, etc.).

Within a function or method '@' behaves like a local variable, i.e. its value is
automatically saved upon function entry and restored at exit.

For example, to read the current input channel until EOF, and print the square
of every item which is a number:

# Nim supports single-line comments

var x = 0 ## Documentation comments start with double hash characters.

var y = 0 ## Documentation comments are a proper part of the syntax (they're not discarded by parser, and a real part of AST).

#[
There are also multi-line comments
Everything inside of #[]# is commented.
]#

# You can also discard multiline statements:

discard """This can be considered as a "comment" too
This is multi-line"""

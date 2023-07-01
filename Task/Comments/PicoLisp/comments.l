# The rest of the line is ignored
#{
   This is a
   multiline comment
}#
NIL
Immediately stop reading this file. Because all text in the input file following
a top-level 'NIL' is ignored.

This is typically used conditionally, with a read-macro expression like
`*Dbg
so that this text is only read if in debugging mode.

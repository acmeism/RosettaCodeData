fn main() {
    // In Zen C, I/O is not handled like in C. While 'printf' or 'puts'
    // among others are still available, Zen C also has special keywords,
    // like 'println' or 'print' (stdout) and 'eprintln' or 'eprint' (stderr).
    // Each one of these keywords also has an implicit form.
    // -> "..." is the same as println "..."
    // -> "...".. is the same as print "..."
    // -> !"..." is the same as eprintln "..."
    // -> !"...".. is the same as eprint "..."
    "Hello, World!"
}

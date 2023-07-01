grammar BraceExpansion {
    token TOP  { ( <meta> | . )* }
    token meta { '{' <alts> '}' | \\ .  }
    token alts { <alt>+ % ',' }
    token alt  { ( <meta> | <-[ , } ]> )* }
}

sub crosswalk($/) {
    |[X~] flat '', $0.map: -> $/ { $<meta><alts><alt>.&alternatives or ~$/ }
}

sub alternatives($_) {
    when :not { () }
    when 1    { '{' X~ $_».&crosswalk X~ '}' }
    default   { $_».&crosswalk }
}

sub brace-expand($s) { crosswalk BraceExpansion.parse($s) }

# Testing:

sub bxtest(*@s) {
    for @s -> $s {
        say "\n$s";
        for brace-expand($s) {
            say "    ", $_;
        }
    }
}

bxtest Q:to/END/.lines;
    ~/{Downloads,Pictures}/*.{jpg,gif,png}
    It{{em,alic}iz,erat}e{d,}, please.
    {,{,gotta have{ ,\, again\, }}more }cowbell!
    a{b{1,2}c
    a{1,2}b}c
    a{1,{2},3}b
    more{ darn{ cowbell,},}
    ab{c,d\,e{f,g\h},i\,j{k,l\,m}n,o\,p}qr
    {a,{\,b}c
    a{b,{{c}}
    {a{\}b,c}d
    END

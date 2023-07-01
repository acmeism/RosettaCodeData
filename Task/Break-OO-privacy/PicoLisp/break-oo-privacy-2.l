: (string> Foo)                        # Access via method call
-> "Hello, I am Eric"

: (get Foo '"_name")                   # Direct access doesn't work
-> NIL

: (get Foo (loc "_name" +Example))     # Locating the transient symbol works
-> "Eric"

: (put Foo (loc "_name" +Example) "Edith")
-> "Edith"

: (string> Foo)                        # Ditto
-> "Hello, I am Edith"

: (get Foo '"_name")
-> NIL

: (get Foo (loc "_name" +Example))
-> "Edith"

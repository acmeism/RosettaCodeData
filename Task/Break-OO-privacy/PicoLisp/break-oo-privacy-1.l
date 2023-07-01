(class +Example)
# "_name"

(dm T (Name)
   (=: "_name" Name) )

(dm string> ()
   (pack "Hello, I am " (: "_name")) )

(====)  # Close transient scope

(setq Foo (new '(+Example) "Eric"))

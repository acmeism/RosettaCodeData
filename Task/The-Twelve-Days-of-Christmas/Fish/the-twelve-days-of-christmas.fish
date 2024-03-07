> 0 7 .                (0,0): Vector. Jumps to main, then used for sub returns
> 0 f 5 + .            (0,1): Print a NUL-terminated string
> 6 6 * 9 + f 8 + .    (0,2): Pop N, push Nth (e.g. 1 -> "first")
> 0 f 8 + .            (0,3): Pop N, push gift countdown starting from N.
> 0 f 1 + .            (0,4): Jump to line in range 16-30

main:
> 1                                                    \
/ a "On the " 0                                        <
\ "a" 4 0 p 0 1 .
> "b" 4 0 p : 0 2 .
> "c" 4 0 p 0 1 .
>                                                   \
/ " day of Christmas, my true love sent to me:" a 0 /
> "f" 4 0 p 0 1 .
> "1" 6 4 p "4" 4 0 p : 0 3 .
> "2" 6 4 p 0 1 .
> 1 + : c ) ?\                                         /
             ;

> : ?\ ~ 0 0 .
\ o  /                                                    >   0 0 .
                                                          ^ "first" 0 ~    \
>                                     \      > 1 - : ?\                    /
/ "A partridge in a pear tree." a 0 & <      /        /   ^ "second" 0 ~   \
\ & 1 - : ?\ ~ 0 0 .                         \ 1 - : ?\                    /
           \                  \              /        /   ^ "third" 0 ~    \
/ "Two turtle doves and" a &  /              \ 1 - : ?\                    /
\ & 1 - : ?\ ~ 0 0 .                         /        /   ^ "fourth" 0 ~   \
           \               \                 \ 1 - : ?\                    /
/ "Three French hens," a & /                 /        /   ^ "fifth" 0 ~    \
\ & 1 - : ?\ ~ 0 0 .                         \ 1 - : ?\                    /
           \                \                /        /   ^ "sixth" 0 ~    \
/ "Four calling birds," a & /                \ 1 - : ?\                    /
\ & 1 - : ?\ ~ 0 0 .                         /        /   ^ "seventh" 0 ~  \
           \             \                   \ 1 - : ?\                    /
/ "Five gold rings," a & /                   /        /   ^ "eighth" 0 ~   \
\ & 1 - : ?\ ~ 0 0 .                         \ 1 - : ?\                    /
           \                \                /        /   ^ "ninth" 0 ~    \
/ "Six geese a-laying," a & /                \ 1 - : ?\                    /
\ & 1 - : ?\ ~ 0 0 .                         /        /   ^ "tenth" 0 ~    \
           \                    \            \ 1 - : ?\                    /
/ "Seven swans a-swimming," a & /            /        /   ^ "eleventh" 0 ~ \
\ & 1 - : ?\ ~ 0 0 .                         \ 1 - : ?\                    /
           \                   \                      \                    \
/ "Eight maids a-milking," a & /                          ^ "twelfth" 0 ~  /
\ & 1 - : ?\ ~ 0 0 .
           \                 \
/ "Nine ladies dancing," a & /
\ & 1 - : ?\ ~ 0 0 .
           \                 \
/ "Ten lords a-leaping," a & /
\ & 1 - : ?\ ~ 0 0 .
           \                  \
/ "Eleven pipers piping," a & /
\ & 1 - : ?\ ~ 0 0 .
           \                      \
/ "Twelve drummers drumming," a & /
\ & ~ 0 0 .

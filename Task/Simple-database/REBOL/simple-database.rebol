rebol [author: "Nick Antonaccio"]
write/append %rdb ""  db: load %rdb
switch system/options/args/1 [
    "new" [write/append %rdb rejoin [now " " mold/only next system/options/args newline]]
    "latest" [print copy/part tail sort/skip db 4 -4]
    "latestcat" [
        foreach cat unique extract at db 3 4 [
            t: copy []
            foreach [a b c d] db [if c = cat [append t reduce [a b c d]]]
            print copy/part tail sort/skip t 4 -4
        ]
    ]
    "sort" [probe sort/skip db 4]
]
halt

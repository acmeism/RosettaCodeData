Rebol []

comma-quibbling: func [block] [
    rejoin [
        "^{"

        to-string use [s] [
            s: copy block
            s: next s
            forskip s 2 [insert s either tail? next s [" and "] [", "]]
            s: head s
        ]

        "^}"
    ]
]

foreach t [[] [ABC] [ABC DEF] [ABC DEF G H]] [print comma-quibbling t]

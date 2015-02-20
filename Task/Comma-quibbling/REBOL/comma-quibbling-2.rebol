Rebol []

; builds string instead of using an intermediate block

comma-quibbling: func [block /oxford /local s length] [
    length: length? block
    rejoin [
        "^{"

        either length < 2 [to-string block] [
            s: to-string block/1
            for n 2 (length - 1) 1 [repend s [", " pick block n]]
            if all [oxford (length > 2)] [append s ","]
            repend s [" and " last block]
        ]

        "^}"
    ]
]

test: [[] [ABC] [ABC DEF] [ABC DEF G H]]
foreach t test [print comma-quibbling t]
print "Now with Oxford comma"
foreach t test [print comma-quibbling/oxford t]

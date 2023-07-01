Exception subclass: #U0.
Exception subclass: #U1.

Object subclass: Foo [

    bazCount := 0.

    foo
        [2 timesRepeat:
            [ "==>" [self bar] "<=="
                on: U0
                do:
                    [:sig |
                    'Call to bar was aborted by exception U0' printNl.
                    sig return]]]

    bar
        [self baz]

    baz
        [bazCount := bazCount + 1.
        bazCount = 1 ifTrue: [U0 new signal].
        bazCount = 2 ifTrue: [U1 new signal].
        "Thirds time's a charm..."]
]

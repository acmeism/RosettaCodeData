Object subclass: CatchThemAll [
    foo [ 'foo received' displayNl ]

    bar [ 'bar received' displayNl ]

    doesNotUnderstand: aMessage [
      ('message "' , (aMessage selector asString) , '"') displayNl.
      (aMessage arguments) do: [ :a |
        'argument: ' display. a printNl.
      ]
    ]
]

|a| a := CatchThemAll new.
a foo.
a bar.
a weCanDoIt.
a theyCanToo: 'eat' and: 'walk'.

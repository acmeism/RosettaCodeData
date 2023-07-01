dict := Dictionary new.
configFile asFilename readingLinesDo:[:line |
    (line isEmpty or:[ line startsWithAnyOf:#('#' ';') ]) ifFalse:[
        s := line readStream.
        (s skipSeparators; atEnd) ifFalse:[
            |optionName values|
            optionName := s upToSeparator.
            values := (s upToEnd asCollectionOfSubstringsSeparatedBy:$,)
                         collect:[:each | each withoutSeparators]
                         thenSelect:[:vals | vals notEmpty].
            dict at:optionName asLowercase put:(values isEmpty
                                                ifTrue:[true]
                                                ifFalse:[
                                                   values size == 1
                                                     ifTrue:[values first]
                                                     ifFalse:[values]]).
        ]
    ].
]

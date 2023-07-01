|task|
task := [:inStream :outStream |
    |processLine|

    processLine :=
        [
            |a b|
            a := Integer readFrom: inStream.
            b := Integer readFrom: inStream.
            "is validation part of the task?"
            self assert:( a between:-1000 and: 1000).
            self assert:( b between:-1000 and: 1000).
            outStream print (a+b); cr.
        ].

    [ inStream atEnd ] whileFalse:processLine.
].

task value: ( 'dataIn.txt' asFilename readStream) value:Transcript.

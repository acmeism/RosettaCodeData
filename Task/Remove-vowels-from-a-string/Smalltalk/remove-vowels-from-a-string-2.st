out := in reject:#isVowel.   " cool: symbols understand value: "

out := in select:[:ch | ch isVowel not].

out := in reject:[:ch | 'aeiou' includes:ch asLowercase ].

out := in reject:[:ch | #( $a $e $i $o $u ) includes:ch asLowercase ].

out := in reject:[:ch | 'AaEeIiOoUu' includes:ch ].

out := String streamContents:[:s |
    in do:[:ch |
        ch isVowel ifFalse:[ s nextPut:ch ]
    ]]

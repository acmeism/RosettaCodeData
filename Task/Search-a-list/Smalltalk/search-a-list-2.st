| haystack |
haystack := 'Zig,Zag,Wally,Ronald,Bush,Krusty,Charlie,Bush,Bozo' subStrings: $,.
[
    { 'Washington' . 'Bush' . 'Ronald' } do: [:word |
      |firstIdx lastIdx|

      firstIdx := haystack
                    indexOf:word
                    ifAbsent:[
                        ProceedableError raiseRequestWith:word errorString:'not found'.
                        0
                    ].
      firstIdx = 0 ifFalse:[
          (lastIdx := haystack lastIndexOf:word) = firstIdx
              ifTrue:[  e'the first index of {word} is {firstIdx}' printCR ]
              ifFalse:[  e'the last index of {word} is {lastIdx}' printCR ]]
    ]
] on:Error do:[:ex |
    e'{ex description} exception raised for: {ex parameter}' printCR.
    'but I don''t care and proceed...' printCR.
    ex proceed.
]

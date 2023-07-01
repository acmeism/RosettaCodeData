26 printStringRadix:16 -> '1A'
Integer readFrom:'1A' radix:16 -> 26

2 to:36 do:[:radix |
    'radix %2d: %s\n' printf:{radix . 100 printStringRadix:radix } on:Transcript.
].

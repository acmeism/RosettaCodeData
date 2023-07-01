USING: formatting locals ;
IN: scratchpad
[let
    "Benjamin" :> dog
    "Samba"    :> Dog
    "Bernie"   :> DOG
    { dog Dog DOG } "There are three dogs named %s, %s, and %s." vprintf
]

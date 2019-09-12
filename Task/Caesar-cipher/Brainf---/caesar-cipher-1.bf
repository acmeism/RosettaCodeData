                                    Author: Ettore Forigo | Hexwell

+                                   start the key input loop
[
                                    memory: | c | 0 | cc | key |
                                              ^

    ,                               take one character of the key

                                    :c : condition for further ifs
                                    != ' ' (subtract 32 (ascii for ' '))
    --------------------------------

                                    (testing for the condition deletes it so duplication is needed)
    [>>+<+<-]                       duplicate
    >                               |
    [<+>-]                          |
    >                               |  :cc : copy of :c

    [                               if :cc
                                    |
        >                           |  :key : already converted digits
                                    |
        [>++++++++++<-]             |  multiply by 10
        >                           |  |
        [<+>-]                      |  |
        <                           |  |
                                    |
        <                           |  :cc
        [-]                         |  clear (making the loop an if)
    ]                               |

    <<                              :c

    [>>+<+<-]                       duplicate
    >                               |
    [<+>-]                          |
    >                               |  :cc

    [                               if :cc
        ----------------            |  subtract 16 (difference between ascii for ' ' (already subtracted before) and ascii for '0'
                                    |    making '0' 0; '1' 1; etc to transform ascii to integer)
                                    |
        [>+<-]                      |  move/add :cc to :key
    ]                               |

    <<                              :c
]

                                    memory: | 0 | 0 | 0 | key |
                                              ^

>>>                                 :key

[<<<+>>>-]                          move key

                                    memory: | key | 0 | 0 | 0 |
                                                            ^
<                                                       ^
+                                   start the word input loop
[
                                    memory: | key | 0 | c | 0 | cc |
                                                        ^

    ,                               take one character of the word

                                    :c : condition for further if
                                    != ' ' (subtract 32 (ascii for ' '))
    --------------------------------

    [>>+<+<-]                       duplicate
    >                               |
    [<+>-]                          |
    >                               |  :cc : copy of :c

    [                               if :cc
                                    |  subtract 65 (difference between ascii for ' ' (already subtracted before) and ascii for 'a'; making a 0; b 1; etc)
        -----------------------------------------------------------------
                                    |
        <<<<                        |  :key
                                    |
        [>>>>+<<<+<-]               |  add :key to :cc := :shifted
        >                           |  |
        [<+>-]                      |  |
                                    |
                                    |  memory: | key | 0 | c | 0 | cc/shifted | 0 | 0 | 0 | 0 | 0 | divisor |
                                    |                  ^
                                    |
        >>>>>>>>>                   |  :divisor
        ++++++++++++++++++++++++++  |  = 26
                                    |
        <<<<<<                      |  :shifted
                                    |
                                    |  memory: | shifted/remainder | 0 | 0 | 0 | 0 | 0 | divisor |
                                    |                   ^
                                    |
                                    |  shifted % divisor
        [                           |  |  while :remainder
                                    |  |  |
                                    |  |  |  memory: | shifted | 0 | 0 | 0 | 0 | 0 | divisor | 0 |
                                    |  |  |               ^
                                    |  |  |
            [>>>>>>>+<<<<+<<<-]     |  |  |  duplicate :cshifted : copy of shifted
                                    |  |  |
                                    |  |  |  memory: | 0 | 0 | 0 | shifted | 0 | 0 | divisor | cshifted |
                                    |  |  |            ^
            >>>>>>                  |  |  |  :divisor                                   ^
                                    |  |  |
            [<<+>+>-]               |  |  |  duplicate
            <                       |  |  |  |
            [>+<-]                  |  |  |  |
            <                       |  |  |  |  :cdiv : copy of divisor
                                    |  |  |
                                    |  |  |  memory: | 0 | 0 | 0 | shifted | cdiv | 0 | divisor | cshifted |
                                    |  |  |                                    ^
                                    |  |  |
                                    |  |  |  subtract :cdiv from :shifted until :shifted is 0
            [                       |  |  |  |  while :cdiv
                <                   |  |  |  |  |  :shifted
                                    |  |  |  |  |
                [<<+>+>-]           |  |  |  |  |  duplicate
                <                   |  |  |  |  |  |
                [>+<-]              |  |  |  |  |  |
                <                   |  |  |  |  |  | :csh
                                    |  |  |  |  |
                                    |  |  |  |  |  memory: | 0 | csh | 0 | shifted/remainder | cdiv | 0 | divisor | cshifted |
                                    |  |  |  |  |                 ^
                                    |  |  |  |  |
                                    |  |  |  |  |  subtract 1 from :shifted if not 0
                [                   |  |  |  |  |  |  if :csh
                    >>-<<           |  |  |  |  |  |  |  subtract 1 from :shifted
                    [-]             |  |  |  |  |  |  |  clear
                ]                   |  |  |  |  |  |  |
                                    |  |  |  |  |
                >>>                 |  |  |  |  |  :cdiv
                -                   |  |  |  |  |  subtract 1
            ]                       |  |  |  |  |
                                    |  |  |
                                    |  |  |
                                    |  |  |  memory: | 0 | 0 | 0 | remainder | 0 | 0 | divisor | cshifted |
                                    |  |  |                                    ^
            <                       |  |  |  :remainder                ^
                                    |  |  |
            [>+<<<<+>>>-]           |  |  |  duplicate
                                    |  |  |
                                    |  |  |  memory: | remainder | 0 | 0 | 0 | crem | 0 | divisor | shifted/modulus |
                                    |  |  |                                ^
            >                       |  |  |  :crem                               ^
                                    |  |  |
                                    |  |  |  clean up modulus if a remainder is left
            [                       |  |  |  if :crem
                >>>[-]<<<           |  |  |  |  clear :modulus
                [-]                 |  |  |  |  clear
            ]                       |  |  |  |
                                    |  |  |
                                    |  |  |  if subtracting :cdiv from :shifted left a remainder we need to do continue subtracting;
                                    |  |  |  otherwise modulus is the modulus between :divisor and :shifted
                                    |  |  |
            <<<<                    |  |  |  :remainder
        ]                           |  |  |
                                    |
                                    |  memory: | 0 | 0 | 0 | 0 | 0 | 0 | divisor | modulus | 0 | cmod | eq26 |
                                    |            ^
                                    |
        >>>>>>>                     |  :modulus
                                    |
        [>>+<+<-]                   |  duplicate
        >                           |  |
        [<+>-]                      |  |
        >                           |  |  :cmod : copy of :modulus
                                    |
                                    |  memory: | 0 | 0 | 0 | 0 | 0 | 0 | divisor | modulus | 0 | cmod | eq26 |
                                    |                                                              ^
                                    |
        --------------------------  |  subtract 26
                                    |
        >                           |  :eq26 : condition equal to 26
        +                           |  add 1 (set true)
                                    |
        <                           |  :cmod
        [                           |  if :cmod not equal 26
            >-<                     |  |  subtract 1 from :eq26 (set false)
            [-]                     |  |  clear
        ]                           |  |
                                    |
        >                           |  :eq26
                                    |
        [                           |  if :eq26
            <<<[-]>>>               |  |  clear :modulus
            [-]                     |  |  clear
        ]                           |  |
                                    |
                                    |  the modulus operation above gives 26 as a valid modulus; so this is a workaround for setting a
                                    |  modulus value of 26 to 0
                                    |
        <<<<                        |
        [-]                         |  clear :divisor
                                    |
                                    |  memory: | c | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | modulus |
                                    |                                            ^
        >                           |  :modulus                                         ^
        [<<<<<<<+>>>>>>>-]          |  move :modulus
                                    |
                                    |  memory: | c | 0 | modulus/cc | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
                                    |                                                         ^
        <<<<<<<                     |  :modulus/cc            ^
                                    |
                                    |  add 97 (ascii for 'a'; making 0 a; 1 b; etc)
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        .                           |  print
        [-]                         |  clear
    ]                               |

                                    memory: | c | 0 | modulus/cc |
                                                           ^
    <<                                 :c     ^
]

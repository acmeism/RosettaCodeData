;; A Rebol quine - a program that outputs its own source code
;; This demonstrates self-referential code and metaprogramming concepts

Rebol []                    ;; Standard Rebol header (minimal version)

q: [                        ;; Define q as a block containing the program logic
    print [                 ;; Print function to output the result
        "Rebol [] q:"       ;; First part: literal string for the header and variable declaration
        mold q              ;; Second part: convert the block q back to its source representation
        "do q"              ;; Third part: literal string for the execution command
    ]
]

do q                        ;; Execute the block q, which prints the entire program

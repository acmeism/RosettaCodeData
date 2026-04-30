test: func [str [string!]][
    ;; Print a simple report about the string: its literal form, whether it's empty, and the word "empty"
    print [
        mold str                        ;; mold: show the string as a literal (quotes visible)
        pick ["is" "isn't"] empty? str  ;; choose "is" if empty, otherwise "isn't"
        "empty"                         ;; trailing label for readability
    ]
]

test str: copy ""       ;; create a new empty string and test it
append str "abc"        ;; add content to the string
test str                ;; test the non-empty string
clear str               ;; remove all content, making it empty again
test str                ;; test the re-emptied string

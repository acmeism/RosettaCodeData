Rebol [
    title: "Rosetta code: Balanced brackets"
    file:  %Balanced_brackets.r3
    url:   https://rosettacode.org/wiki/Balanced_brackets
]

;; Returns TRUE if all square brackets in `str` are properly nested and balanced
balanced?: function/with [str][parse str rule][
    ;; Recursive rule: a balanced group is [ followed by any nested balanced groups, then ]
    balanced-brackets: [#"[" any balanced-brackets #"]"]
    ;; Full string must consist entirely of balanced groups with nothing left over
    rule: [any balanced-brackets end]
]

;; Test: generate 10 random substrings of bracket pairs and check each
random/seed 2
repeat i 10 [
    str: random copy/part "[][][][][][][][][][]" i * 2  ;; shuffle first i*2 chars
    res: pick ["balanced" "unbalanced"] balanced? str   ;; label the result
    printf [-2 ". " 11] reduce [i res mold str]         ;; print index, verdict, string
]

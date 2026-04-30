Rebol [
    title: "Rosetta code: Levenshtein distance"
    file:  %Levenshtein_distance.r3
    url:   https://rosettacode.org/wiki/Levenshtein_distance
]

levenshtein: function [
    "Returns the Levenshtein distance between two strings"
    s1 [string!]
    s2 [string!]
][
    if s1 = s2   [return 0]                        ;; identical
    if empty? s1 [return length? s2]               ;; s1 empty: insert all of s2
    if empty? s2 [return length? s1]               ;; s2 empty: delete all of s1

    ;; put shorter string in s2 to keep row as small as possible
    if (length? s1) < length? s2 [set [s1 s2] reduce [s2 s1]]
    m: length? s1
    n: length? s2
    ;; Single row of n+1 integers, seeded with 0..n
    row: append clear [] 0                         ;; row/1 = 0; rest filled below
    repeat j n [append row j]                      ;; seed: 0,1,2..n (delete j chars)
    repeat i m [
        prev: row/1                                ;; save d[i-1][j-1] before overwrite
        row/1: i                                   ;; delete all of s1[1..i]
        repeat j n [
            save: row/(j + 1)                      ;; stash current cell before update
            row/(j + 1): min min
                row/:j + 1                         ;; insert s2/j
                row/(j + 1) + 1                    ;; delete s1/i
                prev + (pick [0 1] s1/:i = s2/:j)  ;; match or substitute
            prev: save                             ;; slide diagonal one step right
        ]
    ]
    row/(n + 1)                                    ;; bottom-right = final distance
]

; Examples:
print levenshtein "kitten"      "sitting"          ;== 3
print levenshtein "flaw"        "lawn"             ;== 2
print levenshtein "rosettacode" "raisethysword"    ;== 8
print levenshtein "saturday"    "sunday"           ;== 3
print levenshtein "sleep"       "fleeting"         ;== 5

Rebol [
    title: "Rosetta code: Find common directory path"
    file:  %Find_common_directory_path.r3
    url:   https://rosettacode.org/wiki/Find_common_directory_path
]

common-path-prefix: function [
    "Returns the longest common path prefix from a list of path strings"
    paths [block!]
][
    if empty?  paths [return none]
    ref: paths/1                           ;; reference path (first entry)
    pos: 1
    ;; using `pick` instead of path syntax, because of possible file! input
    while [rc: pick ref pos] [
        foreach path next paths [          ;; compare same position in all paths
            if rc != pick path pos [       ;; character mismatch
                -- pos                     ;; step back from mismatch
                while [pos > 0] [          ;; backtrack to last separator
                    if #"/" == pick path pos [break]
                    -- pos
                ]
                return copy/part ref pos - 1
            ]
        ]
        ++ pos
    ]
    copy ref                               ;; ref is shortest; return it in full
]

foreach [title paths expected][
    "Task data" [
        "/home/user1/tmp/coverage/test"
        "/home/user1/tmp/covert/operator"
        "/home/user1/tmp/coven/members"
    ]   "/home/user1/tmp"

    "No common prefix" [
        "/home/user1/tmp"
        "/etc/passwd"
    ]   ""

    "Single path" [
        %/home/user1/tmp/coverage/test
    ]   %/home/user1/tmp/coverage/test

    "Identical paths" [
        "/home/user1/tmp"
        "/home/user1/tmp"
    ]   "/home/user1/tmp"

    "Partial segment match" [
        "/home/user1/tmpx"
        "/home/user1/tmp/"
    ]   "/home/user1"

    "One path is prefix of another" [
        %/home/user1/tmp
        %/home/user1/tmp/coverage/test
    ]   %/home/user1/tmp

    "Empty block" [] _
][
    prin  [lf as-yellow title mold paths]
    print ["  " as-green mold result: common-path-prefix paths]
    if result != expected [
        print [as-red "FAILED!" "Should be:" mold expected]
    ]
]

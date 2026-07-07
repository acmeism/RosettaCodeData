Rebol [
    title: "Rosetta code: Unix/ls"
    file:  %Unix-ls.r3
    url:   https://rosettacode.org/wiki/Unix/ls
]

;; create some directory structure
make-dir/deep %foo/bar
write %foo/bar/1 "11111"
write %foo/bar/2 "2222222"
write %foo/bar/a "aaaaaaaaaa"
write %foo/bar/b "bbbbbbbbbb"

parse [
    "List single directory:"
    [list-dir %foo/]

    "List recursive directory:"
    [list-dir/r %foo/]

    "Read files from a directory:"
    [probe read %foo/bar/]

    "Using call:"
    [call/shell/wait either system/platform = 'Windows ["dir .\foo\bar"]["ls -la ./foo/bar"]]
][
    some [
        set title: string! (print as-yellow title)
        some [
            set test: block! (print mold/only test try test)
        ]
        (print "")
    ]
]

;; cleanup
delete-dir %foo/

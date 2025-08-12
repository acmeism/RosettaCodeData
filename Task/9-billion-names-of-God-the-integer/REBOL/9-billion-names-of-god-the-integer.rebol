Rebol [
    title: "Rosetta code: 9 billion names of God the integer"
    file:  %9_billion_names_of_God_the_integer.r3
    url:    https://rosettacode.org/wiki/9_billion_names_of_God_the_integer
    needs:  3.0.0
    note:  {Based on Red language version}
]
names-of-god: function/with [
    row   [integer!] "row number (>= 1)"
    /show "Display intermediate results"
    /all  "When showing, print all intermediate data"
][
    ;; Validate input - require row >= 1, otherwise trigger a runtime error
    assert [row >= 1]

    ;; If /show refinement is used, display results for the given row
    if show [
        ;; Ensure nums/:row is computed; if not, recursively compute it
        unless nums/:row [names-of-god row]

        ;; Loop from 1 to row
        repeat i row [
            either all [          ;; If /all refinement is used, display extra details
                probe reduce [i nums/:i sums/:i]  ;; Show index, sequence, and sum
            ][
                print nums/:i     ;; Otherwise, just print the sequence
            ]
        ]
    ]

    ;; Compute a new row from scratch (if row not already computed)...
    unless sum: sums/:row [
        out: clear []              ;; Temporary storage for row's elements
        half: to integer! row / 2  ;; Middle position of the row

        ;; Ensure all required previous rows exist; generate missing ones
        if row - 1 > last: length? nums [
            repeat i row - last - 1 [
                names-of-god last + i
            ]
        ]

        ;; Build the `out` block for this row
        repeat col row - 1 [
            ;; Special case: the middle element
            either col = (half + 1) [
                append out at nums/(row - 1) half   ;; Insert from previous row's middle
                break                              ;; Stop building here
            ][
                ;; General case: append sum-part of two earlier sequences
                append out sum-part nums/(row - col) col
            ]
        ]

        ;; Compute the sum of the row
        sum: 0.0
        forall out [
            sum: sum + out/1
        ]

        ;; Cache the computed row and its sum
        sums/:row: sum
        nums/:row: copy out
        clear out
    ]
    sums/:row ;; Return sum of the row
][
    ;; ===== WITH BLOCK (local helper definitions and persistent state) =====

    ;; Helper function: sum the first `count` elements from the given block `nums`
    sum-part: function [nums [block!] count [integer!]][
        out: 0.0
        loop count [
            out: out + nums/1
            if empty? nums: next nums [break]  ;; Stop if we've exhausted the block
        ]
        ;; If within integer range, convert to integer
        if out <= 0#7fffffffffffffff [out: to integer! out]
        out
    ]

    ;; Persistent storage for each computed row (map! with row → sequence)
    ;; Start with base cases:
    ;; row 1 = [1]
    ;; row 2 = [1 1]
    nums: make map! [1 [1] 2 [1 1]]

    ;; Persistent storage for row sums (map! with row → sum)
    ;; Base sums: row 1 sum = 1, row 2 sum = 2
    sums: make map! [1 1 2 2]
]



print "rows: ^/"
names-of-god/show 25

print "^/sums: ^/"
probe names-of-god 23
probe names-of-god 123
probe names-of-god 1234

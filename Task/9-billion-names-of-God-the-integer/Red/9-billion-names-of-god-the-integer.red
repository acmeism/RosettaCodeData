Red []

context [
    sum-part: function [nums [block!] count [integer!]][
        out: 0.0
        loop count [
            out: out + nums/1
            if empty? nums: next nums [break]
        ]
        out
    ]
    nums: make map! [1 [1] 2 [1 1]]
    sums: make map! [1 1 2 2]
    set 'names function [row /show /all][
        if row < 1 [cause-error 'user 'message "Argument needs to be >= 1"]
        if show [
            unless nums/:row [names row]
            repeat i row [either all [probe reduce [i nums/:i sums/:i]][print nums/:i]]
        ]
        either sums/:row [sums/:row][
            out: clear []
            half: to integer! row / 2
            if row - 1 > last: length? nums [
                repeat i row - last - 1 [names last + i]
            ]
            repeat col row - 1 [
                either col = (half + 1) [
                    append out at nums/(row - 1) half
                    break
                ][
                    append out sum-part nums/(row - col) col
                ]
            ]
            also sums/:row: sum nums/:row: copy out  clear out
        ]
    ]
]

print "rows: ^/"
names/show 25
print "^/sums: ^/"
probe names 23
probe names 123
probe names 1234

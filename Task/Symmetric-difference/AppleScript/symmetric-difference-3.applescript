on symmetricDifference(a, b)
    set output to {}
    repeat 2 times
        repeat with thisItem in a
            set thisItem to thisItem's contents
            tell {thisItem}
                if (not ((it is in b) or (it is in output))) then set end of output to thisItem
            end tell
        end repeat
        set {a, b} to {b, a}
    end repeat

    return output
end symmetricDifference

on task()
    set a to {"John", "Serena", "Bob", "Mary", "Serena"}
    set b to {"Jim", "Mary", "John", "Jim", "Bob"}
    return symmetricDifference(a, b)
end task

task()

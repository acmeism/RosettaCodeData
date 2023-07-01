on run
    set fns to {}

    repeat with i from 1 to 10
        set end of fns to closure(i)
    end repeat

    |λ|() of item 3 of fns
end run

on closure(x)
    script
        on |λ|()
            x * x
        end |λ|
    end script
end closure

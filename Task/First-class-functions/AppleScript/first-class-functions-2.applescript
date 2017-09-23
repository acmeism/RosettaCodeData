on run

    set fs to {sin_, cos_, cube_}
    set afs to {asin_, acos_, croot_}

    -- Form a list of three composed function objects,
    -- and map testWithHalf() across the list to produce the results of
    -- application of each composed function (base function composed with inverse) to 0.5

    script testWithHalf
        on |λ|(f)
            mReturn(f)'s |λ|(0.5)
        end |λ|
    end script

    map(testWithHalf, zipWith(mCompose, fs, afs))

    --> {0.5, 0.5, 0.5}
end run

-- Simple composition of two unadorned handlers into
-- a method of a script object
on mCompose(f, g)
    script
        on |λ|(x)
            mReturn(f)'s |λ|(mReturn(g)'s |λ|(x))
        end |λ|
    end script
end mCompose

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

on sin:r
    (do shell script "echo 's(" & r & ")' | bc -l") as real
end sin:

on cos:r
    (do shell script "echo 'c(" & r & ")' | bc -l") as real
end cos:

on cube:x
    x ^ 3
end cube:

on croot:x
    x ^ (1 / 3)
end croot:

on asin:r
    (do shell script "echo 'a(" & r & "/sqrt(1-" & r & "^2))' | bc -l") as real
end asin:

on acos:r
    (do shell script "echo 'a(sqrt(1-" & r & "^2)/" & r & ")' | bc -l") as real
end acos:

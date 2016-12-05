on run {}

    set lstFn to {sin_, cos_, cube_}
    set lstInvFn to {asin_, acos_, croot_}

    -- Form a list of three composed function objects,
    -- and map testWithHalf() across the list to produce the results of
    -- application of each composed function (base function composed with inverse) to 0.5

    map(testWithHalf, zipWith(mCompose, lstFn, lstInvFn))


    --> {0.5, 0.5, 0.5}

end run

on testWithHalf(mf)
    mf's lambda(0.5)
end testWithHalf

-- Simple composition of two unadorned handlers into
-- a method of a script object
on mCompose(f, g)
    script
        on lambda(x)
            mReturn(f)'s lambda(mReturn(g)'s lambda(x))
        end lambda
    end script
end mCompose

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
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
            property lambda : f
        end script
    end if
end mReturn

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set nx to length of xs
    set ny to length of ys
    if nx < 1 or ny < 1 then
        {}
    else
        set lng to cond(nx < ny, nx, ny)
        set lst to {}
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to lambda(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

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

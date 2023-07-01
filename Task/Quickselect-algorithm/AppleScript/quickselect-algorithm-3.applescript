----------------------- QUICKSELECT ------------------------

-- quickSelect :: Ord a => [a] -> Int -> a
on quickSelect(xxs)
    script
        on |λ|(k)
            script go
                on |λ|(xxs, k)
                    set {x, xs} to {item 1 of xxs, rest of xxs}
                    set {ys, zs} to partition(gt(x), xs)

                    set lng to length of ys
                    if k < lng then
                        |λ|(ys, k)
                    else
                        if k > lng then
                            |λ|(zs, k - lng - 1)
                        else
                            x
                        end if
                    end if
                end |λ|
            end script
            if 0 ≤ k and k < length of xxs then
                tell go to |λ|(xxs, k)
            else
                missing value
            end if
        end |λ|
    end script
end quickSelect


--------------------------- TEST ---------------------------
on run
    set xs to {9, 8, 7, 6, 5, 0, 1, 2, 3, 4}
    map(quickSelect(xs), enumFromTo(0, (length of xs) - 1))
end run


----------- GENERAL AND REUSABLE PURE FUNCTIONS ------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo


-- gt :: Ord a => a -> a -> Bool
on gt(x)
    script
        on |λ|(y)
            x > y
        end |λ|
    end script
end gt


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- partition :: (a -> Bool) -> [a] -> ([a], [a])
on partition(p, xs)
    tell mReturn(p)
        set {ys, zs} to {{}, {}}
        repeat with x in xs
            set v to contents of x
            if |λ|(v) then
                set end of ys to v
            else
                set end of zs to v
            end if
        end repeat
    end tell
    {ys, zs}
end partition

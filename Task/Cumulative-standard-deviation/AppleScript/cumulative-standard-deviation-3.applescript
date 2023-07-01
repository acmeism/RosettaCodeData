-------------- CUMULATIVE STANDARD DEVIATION -------------

-- cumulativeStdDevns :: [Float] -> [Float]
on cumulativeStdDevns(xs)
    script go
        on |λ|(sq, x, i)
            set {s, q} to sq
            set _s to x + s
            set _q to q + (x ^ 2)

            {{_s, _q}, ((_q / i) - ((_s / i) ^ 2)) ^ 0.5}
        end |λ|
    end script

    item 2 of mapAccumL(go, {0, 0}, xs)
end cumulativeStdDevns


--------------------------- TEST -------------------------
on run

    cumulativeStdDevns({2, 4, 4, 4, 5, 5, 7, 9})

end run


------------------------- GENERIC ------------------------

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl


-- mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumL(f, acc, xs)
    -- 'The mapAccumL function behaves like a combination of map and foldl;
    -- it applies a function to each element of a list, passing an
    -- accumulating parameter from |Left| to |Right|, and returning a final
    -- value of this accumulator together with the new list.' (see Hoogle)
    script
        on |λ|(a, x, i)
            tell mReturn(f) to set pair to |λ|(item 1 of a, x, i)
            {item 1 of pair, (item 2 of a) & {item 2 of pair}}
        end |λ|
    end script

    foldl(result, {acc, []}, xs)
end mapAccumL


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

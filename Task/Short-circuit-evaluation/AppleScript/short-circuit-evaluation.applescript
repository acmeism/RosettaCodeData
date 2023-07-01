on run

    map(test, {|and|, |or|})

end run

-- test :: ((Bool, Bool) -> Bool) -> (Bool, Bool, Bool, Bool)
on test(f)
    map(f, {{true, true}, {true, false}, {false, true}, {false, false}})
end test



-- |and| :: (Bool, Bool) -> Bool
on |and|(tuple)
    set {x, y} to tuple

    a(x) and b(y)
end |and|

-- |or| :: (Bool, Bool) -> Bool
on |or|(tuple)
    set {x, y} to tuple

    a(x) or b(y)
end |or|

-- a :: Bool -> Bool
on a(bool)
    log "a"
    return bool
end a

-- b :: Bool -> Bool
on b(bool)
    log "b"
    return bool
end b


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    script mf
        property lambda : f
    end script
    set lng to length of xs
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to mf's lambda(item i of xs, i, xs)
    end repeat
    return lst
end map

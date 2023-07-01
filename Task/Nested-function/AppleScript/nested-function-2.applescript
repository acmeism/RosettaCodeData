-- makeList :: String -> String
on makeList(separator)

    -- makeItem :: String -> Int -> String
    script makeItem
        on |λ|(x, i)
            (i & separator & x & linefeed) as string
        end |λ|
    end script

    map(makeItem, ["first", "second", "third"]) as string
end makeList

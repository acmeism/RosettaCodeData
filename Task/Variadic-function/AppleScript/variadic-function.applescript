use framework "Foundation"

-- positionalArgs :: [a] -> String
on positionalArgs(xs)

    -- follow each argument with a line feed
    map(my putStrLn, xs) as string
end positionalArgs

-- namedArgs :: Record -> String
on namedArgs(rec)
    script showKVpair
        on |λ|(k)
            my putStrLn(k & " -> " & keyValue(rec, k))
        end |λ|
    end script

    -- follow each argument name and value with line feed
    map(showKVpair, allKeys(rec)) as string
end namedArgs

-- TEST
on run
    intercalate(linefeed, ¬
        {positionalArgs(["alpha", "beta", "gamma", "delta"]), ¬
            namedArgs({epsilon:27, zeta:48, eta:81, theta:8, iota:1})})

    --> "alpha
    --   beta
    --   gamma
    --   delta
    --
    --   epsilon -> 27
    --   eta -> 81
    --   iota -> 1
    --   zeta -> 48
    --   theta -> 8
    --  "
end run


-- GENERIC FUNCTIONS

-- putStrLn :: a -> String
on putStrLn(a)
    (a as string) & linefeed
end putStrLn

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- allKeys :: Record -> [String]
on allKeys(rec)
    (current application's NSDictionary's dictionaryWithDictionary:rec)'s allKeys() as list
end allKeys

-- keyValue :: Record -> String -> Maybe String
on keyValue(rec, strKey)
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:rec)'s objectForKey:strKey
    if v is not missing value then
        item 1 of ((ca's NSArray's arrayWithObject:v) as list)
    else
        missing value
    end if
end keyValue

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

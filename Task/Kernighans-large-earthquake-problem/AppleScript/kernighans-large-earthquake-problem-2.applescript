use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

property magnitude : 6.0
property fp : "~/Desktop/data.txt"


-------------------------- TEST ---------------------------
on run

    either(identity, identity, ¬
        bindLR(readFileLR(fp), ¬
            report(fp, magnitude)))

end run


-------------------- EARTHQUAKE REPORT --------------------

-- report :: FilePath -> Float -> String -> String
on report(fp, threshold)
    script
        on |λ|(s)
            |Right|(unlines({("Magnitudes above " & magnitude as string) & ¬
                " in " & fp & ":", ""} & ¬
                concatMap(aboveThreshold(threshold), paragraphs of s)))
        end |λ|
    end script
end report


-- aboveThreshold :: Float -> String -> Bool
on aboveThreshold(threshold)
    script
        on |λ|(s)
            if "" ≠ s and threshold < (item -1 of words of s) as number then
                {s}
            else
                {}
            end if
        end |λ|
    end script
end aboveThreshold


-------------------- REUSABLE GENERICS --------------------

-- Left :: a -> Either a b
on |Left|(x)
    {type:"Either", |Left|:x, |Right|:missing value}
end |Left|


-- Right :: b -> Either a b
on |Right|(x)
    {type:"Either", |Left|:missing value, |Right|:x}
end |Right|


-- bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
on bindLR(m, mf)
    if missing value is not |Left| of m then
        m
    else
        mReturn(mf)'s |λ|(|Right| of m)
    end if
end bindLR


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap


-- either :: (a -> c) -> (b -> c) -> Either a b -> c
on either(lf, rf, e)
    if missing value is |Left| of e then
        tell mReturn(rf) to |λ|(|Right| of e)
    else
        tell mReturn(lf) to |λ|(|Left| of e)
    end if
end either


-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity


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


-- readFileLR :: FilePath -> Either String IO String
on readFileLR(strPath)
    set ca to current application
    set e to reference
    set {s, e} to (ca's NSString's ¬
        stringWithContentsOfFile:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath) ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(e))
    if s is missing value then
        |Left|((localizedDescription of e) as string)
    else
        |Right|(s as string)
    end if
end readFileLR


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

------------------ TOKENIZE WITH ESCAPING ----------------

-- tokenize :: String -> Character -> Character -> [String]
on tokenize(str, delimChar, chrEsc)

    script charParse
        -- Record: {esc:Bool, token:String, tokens:[String]}
        -- charParse :: Record -> Character -> Record
        on |λ|(a, x)
            set blnEsc to esc of a
            set blnEscChar to ((not blnEsc) and (x = chrEsc))

            if ((not blnEsc) and (x = delimChar)) then
                set k to ""
                set ks to (tokens of a) & token of a
            else
                set k to (token of a) & cond(blnEscChar, "", x)
                set ks to tokens of (a)
            end if

            {esc:blnEscChar, token:k, tokens:ks}
        end |λ|
    end script

    set recParse to foldl(charParse, ¬
        {esc:false, token:"", tokens:[]}, splitOn("", str))

    tokens of recParse & token of recParse
end tokenize


--------------------------- TEST -------------------------
on run
    script numberedLine
        on |λ|(a, s)
            set iLine to lineNum of a
            {lineNum:iLine + 1, report:report of a & iLine & ":" & tab & s & linefeed}
        end |λ|
    end script

    report of foldl(numberedLine, {lineNum:1, report:""}, ¬
        tokenize("one^|uno||three^^^^|four^^^|^cuatro|", "|", "^"))
end run


-------------------- GENERIC FUNCTIONS -------------------

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


-- splitOn :: String -> String -> [String]
on splitOn(pat, src)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, pat}
    set xs to text items of src
    set my text item delimiters to dlm
    return xs
end splitOn


-- cond :: Bool -> a -> a -> a
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

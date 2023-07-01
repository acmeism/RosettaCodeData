use framework "OSAKit"

on run
    {countSubstring("the three truths", "th"), ¬
        countSubstring("ababababab", "abab")}
end run

on countSubstring(str, subStr)
    return evalOSA("JavaScript", "var matches = '" & str & "'" & ¬
        ".match(new RegExp('" & subStr & "', 'g'));" & ¬
        "matches ? matches.length : 0") as integer
end countSubstring

-- evalOSA :: ("JavaScript" | "AppleScript") -> String -> String
on evalOSA(strLang, strCode)

    set ca to current application
    set oScript to ca's OSAScript's alloc's initWithSource:strCode ¬
        |language|:(ca's OSALanguage's languageForName:(strLang))

    set {blnCompiled, oError} to oScript's compileAndReturnError:(reference)

    if blnCompiled then
        set {oDesc, oError} to oScript's executeAndReturnError:(reference)
        if (oError is missing value) then return oDesc's stringValue as text
    end if

    return oError's NSLocalizedDescription as text
end evalOSA

squeezable_string(str, char){
    for i, ch in StrSplit(str){
        if (ch <> prev) || !InStr(ch, char)
            res .= ch
        prev := ch
    }
    result := "
    (ltrim
    Original string:`t" StrLen(str) " characters`t«««" str "»»»
    Squeezable Character «««" char "»»»
    Resultant string:`t" StrLen(res) " characters`t«««" res "»»»
    )"
    return result
}

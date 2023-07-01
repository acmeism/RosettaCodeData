proc assert {expr} {    ;# for "static" assertions that throw nice errors
    if {![uplevel 1 [list expr $expr]]} {
        set msg "{$expr}"
        catch {append msg " {[uplevel 1 [list subst -noc $expr]]}"}
        tailcall throw {ASSERT ERROR} $msg
    }
}

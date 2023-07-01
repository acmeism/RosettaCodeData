proc xquote string {
    list [string map "' &apos; \\\" &quot; < &gt; > &lt; & &amp;" $string]
}
proc < {name attl args} {
    set res <$name
    foreach {att val} $attl {
        append res " $att='$val'"
    }
    if {[llength $args]} {
        append res >
        set sep ""
        foreach a $args {
            append res $sep $a
            set sep \n
        }
        append res </$name>
    } else {append res />}
    return $res
}
set cmd {< CharacterRemarks {}}
foreach {name comment} {
    April "Bubbly: I'm > Tam and <= Emily"
    "Tam O'Shanter" "Burns: \"When chapman billies leave the street ...\""
    Emily "Short & shrift"
} {
    append cmd " \[< Character {Name [xquote $name]} [xquote $comment]\]"
}
puts [eval $cmd]

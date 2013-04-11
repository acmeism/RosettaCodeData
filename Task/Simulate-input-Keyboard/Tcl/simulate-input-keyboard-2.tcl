package require Tk
pack [text .t]
focus -force .t
foreach c [split "hello world" ""] {
   event generate .t [expr {$c eq " "?"<space>": $c}]
}

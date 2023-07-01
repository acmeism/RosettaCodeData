fconfigure stdin -blocking 0
set ch [read stdin 1]
fconfigure stdin -blocking 1

if {$ch eq ""} {
    # Nothing was read
} else {
    # Got the character $ch
}

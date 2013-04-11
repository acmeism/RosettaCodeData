package require Tk
proc update {} {
    .clockface configure -text [clock format [clock seconds]]
    after 1000 update ; # call yourself in a second
}
# now just create the 'clockface' and call ;update' once:
pack [label .clockface]
update

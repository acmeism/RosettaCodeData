oo::class create example {
    # Note that this is otherwise syntactically the same as a local variable
    variable objVar
    constructor {} {
        set objVar "This is an object variable"
    }
    method showOff {} {
        puts "variable objVar holds \"$objVar\""
    }
}
[example new] showOff

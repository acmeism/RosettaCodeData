oo::define List {
    method for {varName script} {
        upvar 1 $varName var
        set elem [self]
        while {$elem ne ""} {
            set var [$elem value]
            uplevel 1 $script
            set elem [$elem next]
        }
    }
}

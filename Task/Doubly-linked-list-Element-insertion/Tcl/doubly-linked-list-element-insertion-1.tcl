oo::define List {
    method insertBefore {elem} {
        $elem next [self]
        $elem previous $prev
        if {$prev ne ""} {
            $prev next $elem
        }
        set prev $elem
    }
    method insertAfter {elem} {
        $elem previous [self]
        $elem next $next
        if {$next ne ""} {
            $next previous $elem
        }
        set next $elem
    }
}

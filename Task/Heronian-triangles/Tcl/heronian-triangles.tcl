if {[info commands let] eq ""} {

    #make some math look nicer:
    proc let {name args} {
        tailcall ::set $name [uplevel 1 $args]
    }
    interp alias {} = {} expr
    namespace import ::tcl::mathfunc::* ::tcl::mathop::*
    interp alias {} sum {} +

    # a simple adaptation of gcd from http://wiki.tcl.tk/2891
    proc coprime {a args} {
        set gcd $a
        foreach arg $args {
            while {$arg != 0} {
                set t $arg
                let arg = $gcd % $arg
                set gcd $t
                if {$gcd == 1} {return true}
            }
        }
        return false
    }
}

namespace eval Hero {

    # Integer square root:  returns 0 if n is not a square.
    proc isqrt? {n} {
        let r = entier(sqrt($n))
        if {$r**2 == $n} {
            return $r
        } else {
            return 0
        }
    }

    # The square of a triangle's area
    proc squarea {a b c} {
        let s = ($a + $b + $c) / 2.0
        let sqrA = $s * ($s - $a) * ($s - $b) * ($s - $c)
        return $sqrA
    }

    proc is_heronian {a b c} {
        isqrt? [squarea $a $b $c]
    }

    proc primitive_triangles {db max} {
        for {set a 1} {$a <= $max} {incr a} {
            for {set b $a} {$b <= $max} {incr b} {
                let maxc = min($a+$b,$max)
                for {set c $b} {$c <= $maxc} {incr c} {
                    set area [is_heronian $a $b $c]
                    if {$area && [coprime $a $b $c]} {
                        set perimiter [expr {$a + $b + $c}]
                        $db eval {insert into herons (area, perimiter, a, b, c) values ($area, $perimiter, $a, $b, $c)}
                    }
                }
            }
        }
    }
}

proc main {db} {
    $db eval {create table herons (area int, perimiter int, a int, b int, c int)}

    set max 200
    puts "Calculating Primitive Heronian triangles up to size length $max"
    puts \t[time {Hero::primitive_triangles $db $max} 1]

    puts "Total Primitive Heronian triangles with side lengths <= $max:"
    $db eval {select count(1) count from herons} {
        puts "\t$count"
    }

    puts "First ten when ordered by increasing area, perimiter, max side length:"
    $db eval {select * from herons order by area, perimiter, c limit 10} {
        puts "\t($a, $b, $c)  perimiter = $perimiter;  area = $area"
    }

    puts "All of area 210:"
    $db eval {select * from herons where area=210 order by area, perimiter, c} {
        puts "\t($a, $b, $c)  perimiter = $perimiter;  area = $area"
    }
}


package require sqlite3
sqlite3 db :memory:
main db

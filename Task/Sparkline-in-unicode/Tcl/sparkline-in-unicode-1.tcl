package require Tcl 8.6

proc extractValues {series} {
    return [regexp -all -inline {\d+(?:\.\d*)?|\.\d+} $series]
}
proc renderValue {min max value} {
    set band [expr {int(8*($value-$min)/(($max-$min)*1.01))}]
    return [format "%c" [expr {0x2581 + $band}]]
}
proc sparkline {series} {
    set values [extractValues $series]
    set min [tcl::mathfunc::min {*}$values]
    set max [tcl::mathfunc::max {*}$values]
    return [join [lmap v $values {renderValue $min $max $v}] ""]
}

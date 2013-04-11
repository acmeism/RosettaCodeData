package require Tcl 8.5
package require math::statistics

proc isUniform {distribution {significance 0.05}} {
    set count [tcl::mathop::+ {*}[dict values $distribution]]
    set expected [expr {double($count) / [dict size $distribution]}]
    set X2 0.0
    foreach value [dict values $distribution] {
	set X2 [expr {$X2 + ($value - $expected)**2 / $expected}]
    }
    set degreesOfFreedom [expr {[dict size $distribution] - 1}]
    set likelihoodOfRandom [::math::statistics::incompleteGamma \
	[expr {$degreesOfFreedom / 2.0}] [expr {$X2 / 2.0}]]
    expr {$likelihoodOfRandom > $significance}
}

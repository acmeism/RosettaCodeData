#!/usr/bin/env tclsh

 proc dbl2frac {dbl {eps 0.000001}} {
   for {set den 1} {$den<1024} {incr den} {
      set num [expr {round($dbl*$den)}]
      if {abs(double($num)/$den - $dbl) < $eps} break
   }
   list $num $den
 }
#-------------------- That's all... the rest is the test suite
if {[file tail $argv0] eq [file tail [info script]]} {
    foreach {test            -> expected} {
	{dbl2frac 0.518518}  -> {42 81}
	{dbl2frac 0.75}      -> {3 4}
	{dbl2frac 0.9054054} -> {67 74}
    } {
	catch $test res
	if {$res ne $expected} {
	    puts "$test -> $res, expected $expected"
	}
    }
}

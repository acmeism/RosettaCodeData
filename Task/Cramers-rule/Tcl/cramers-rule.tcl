package require math::linearalgebra
namespace path ::math::linearalgebra

# Setting matrix to variable A and size to n
set A [list { 2 -1  5  1} { 3  2  2 -6} { 1  3  3 -1} { 5 -2 -3  3}]
set n [llength $A]
# Setting right side of equation
set right {-3 -32 -47 49}

# Calculating determinant of A
set detA [det $A]

# Apply Cramer's rule
for {set i 0} {$i < $n} {incr i} {
  set tmp $A                    ;# copy A to tmp
  setcol tmp $i $right          ;# replace column i with right side vector
  set detTmp [det $tmp]         ;# calculate determinant of tmp
  set v [expr $detTmp / $detA]  ;# divide two determinants
  puts [format "%0.4f" $v]      ;# format and display result
}

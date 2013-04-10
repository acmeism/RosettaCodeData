% oo::class create summation {
   constructor {} {
       variable v 0
   }
   method add x {
       variable v
       incr v $x
   }
   method value {{var v}} {
       variable $var
       return [set $var]
   }
   destructor {
       variable v
       puts "Ended with value $v"
   }
}
::summation
% set s [summation new]
% set s2 [summation new]
% oo::objdefine $s export varname
% # Do the monkey patch...
% set [$s varname time] "now"
% $s value time
now
% # Show that it is only in one object...
% $s2 value time
can't read "time": no such variable

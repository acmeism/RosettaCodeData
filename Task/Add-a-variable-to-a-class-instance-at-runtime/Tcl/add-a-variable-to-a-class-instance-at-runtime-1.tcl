% package require TclOO
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
% # Do the monkey patch!
% set [info object namespace $s]::time now
now
% # Prove it's really part of the object...
% $s value time
now
%

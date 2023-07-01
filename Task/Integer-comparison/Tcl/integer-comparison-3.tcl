% set i 5;set j 6
% foreach {o s} {< "less than" > "greater than" == equal} {if [list $i $o $j] {puts "$i is $s $j"}}
5 is less than 6
% set j 5
% foreach {o s} {< "less than" > "greater than" == equal} {if [list $i $o $j] {puts "$i is $s $j"}}
5 is equal 5
% set j 4
% foreach {o s} {< "less than" > "greater than" == equal} {if [list $i $o $j] {puts "$i is $s $j"}}
5 is greater than 4

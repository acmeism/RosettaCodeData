@queue = (); # we will simulate a queue in a array

push @queue, (1..5); # enqueue numbers from 1 to 5

print shift @queue,"\n"; # dequeue

print "array is empty\n" unless @queue; # is empty ?

print $n while($n = shift @queue); # dequeue all
print "\n";
print "array is empty\n" unless @queue; # is empty ?

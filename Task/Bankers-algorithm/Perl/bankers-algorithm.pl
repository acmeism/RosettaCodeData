use strict;
use warnings;
use feature 'say';

my @avail =  (3, 1, 1, 2);                              # Available instances of resource
my @maxm  = ([3, 3, 2, 2], [1, 2, 3, 4], [1, 3, 5, 0]); # Maximum R that can be allocated to processes
my @allot = ([1, 2, 2, 1], [1, 0, 3, 3], [1, 2, 1, 0]); # Resources allocated to processes

# Function to find the system is in safe state or not
sub isSafe {
    my($work, $maxm, $allot) = @_;
    my $P = @$allot;            # Number of processes
    my $R = @$work;             # Number of resources
    my @unfinished = (1) x $P;  # Mark all processes as unfinished
    my(@safeSeq,@need);
    for my $i (0..$P-1) {       # Calculating need of each process:
        for my $j (0..$R-1) {   #    maxm instance - allocated instance
           $need[$i][$j] = $$maxm[$i][$j]   - $$allot[$i][$j]
        }
    }

    # While all processes are not finished or system is not in safe state
    my $count = 0;
    while ($count < $P) {
        my $found = 0;
        for my $p (0..$P-1) {
            # While a process is not finished
            if ($unfinished[$p]) {
                # Check if for all resources of current P need is less than work
                my $satisfied;
                LOOP: for my $j (0..$R-1) {
                    $satisfied = $j;
                    last LOOP if $need[$p][$j] > $$work[$j]
                }
                # If all needs of p were satisfied
                if ($satisfied == $R-1) {
                    $$work[$_] += $$allot[$p][$_] for 0..$R-1; # free the resources
                    say 'available resources: ' . join ' ', @$work;
                    push @safeSeq, $p;                         # Add this process to safe sequence
                    $unfinished[$p]  = 1;                      # Mark this process as finished
                    $count += 1;
                    $found = 1
                }
            }
        }
        # If we could not find a next process in safe sequence.
        return 0, "System is not in safe state." unless $found;
    }
    # If system is in safe state then safe sequence will be as below
    return 1, "Safe sequence is: " . join ' ', @safeSeq
}

# Check system is in safe state or not
my($safe_state,$status_message) = isSafe(\@avail, \@maxm, \@allot);
say "Safe state? " . ($safe_state ? 'True' : 'False');
say "Message:    $status_message";

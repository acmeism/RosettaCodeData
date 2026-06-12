my @avail = <3 1 1 2>;                        # Available instances of resource
my @maxm  = <3 3 2 2>, <1 2 3 4>, <1 3 5 0>;  # Maximum resources that can be allocated to processes
my @allot = <1 2 2 1>, <1 0 3 3>, <1 2 1 0>;  # Resources allocated to processes

# Function to find the system is in safe state or not
sub isSafe(\work is copy, \maxm, \allot) {
    my \P          = allot.elems;     # Number of processes
    my \Pool       = (^P).SetHash;    # Process pool
    my \R          = work.elems;      # Number of resources
    my \need       = maxm »-« allot;  # the need matrix
    my @safe-sequence;

    # While all processes are not finished or system is not in safe state
    my $count = 0;
    while $count < P {
        my $found = False;
        for Pool.keys -> \p {
            if all need[p] »≤« work {    # now process can be finished
                work »+=« allot[p;^R];   # Free the resources
                say 'available resources: ' ~ work;
                @safe-sequence.push: p;  # Add this process to safe sequence
                Pool{p}--;               # Remove this process from Pool
                $count += 1;
                $found = True
            }
        }
        # If we could not find a next process in safe sequence
        return False, "System is not in safe state." unless $found;
    }
    # If system is in safe state then safe sequence will be as below
    return True, "Safe sequence is: " ~ @safe-sequence
}

# Check if system is in a safe state
my ($safe-state,$status-message) = isSafe @avail, @maxm, @allot;
say "Safe state? $safe-state";
say "Message:    $status-message";

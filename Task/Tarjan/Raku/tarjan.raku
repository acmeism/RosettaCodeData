sub tarjan (%k) {
    my %onstack;
    my %index;
    my %lowlink;
    my @stack;
    my @connected;

    sub strong-connect ($vertex) {
         state $index      = 0;
         %index{$vertex}   = $index;
         %lowlink{$vertex} = $index++;
         %onstack{$vertex} = True;
         @stack.push: $vertex;
         for |%k{$vertex} -> $connection {
             if not %index{$connection}.defined {
                 strong-connect($connection);
                 %lowlink{$vertex} min= %lowlink{$connection};
             }
             elsif %onstack{$connection} {
                 %lowlink{$vertex} min= %index{$connection};
             }
        }
        if %lowlink{$vertex} eq %index{$vertex} {
            my @node;
            repeat {
                @node.push: @stack.pop;
                %onstack{@node.tail} = False;
            } while @node.tail ne $vertex;
            @connected.push: @node;
        }
    }

    .&strong-connect unless %index{$_} for %k.keys;

    @connected
}

# TESTING

-> $test { say "\nStrongly connected components: ", |tarjan($test).sort».sort } for

# hash of vertex, edge list pairs
(((1),(2),(0),(1,2,4),(3,5),(2,6),(5),(4,6,7)).pairs.hash),

# Same layout test data with named vertices instead of numbered.
%(:Andy<Bart>,
  :Bart<Carl>,
  :Carl<Andy>,
  :Dave<Bart Carl Earl>,
  :Earl<Dave Fred>,
  :Fred<Carl Gary>,
  :Gary<Fred>,
  :Hank<Earl Gary Hank>
)

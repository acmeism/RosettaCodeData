sub print_topo_sort ( %deps ) {
    my %ba;
    for %deps.kv -> $before, @afters {
        for @afters -> $after {
            %ba{$before}{$after} = 1 if $before ne $after;
            %ba{$after} //= {};
        }
    }

    while %ba.grep( not *.value )».key -> @afters {
        say ~@afters.sort;
        %ba{@afters}:delete;
        for %ba.values { .{@afters}:delete }
    }

    say %ba ?? "Cycle found! {%ba.keys.sort}" !! '---';
}

my %deps =
    des_system_lib => < std synopsys std_cell_lib des_system_lib dw02
                                                     dw01 ramlib ieee >,
    dw01           => < ieee dw01 dware gtech                         >,
    dw02           => < ieee dw02 dware                               >,
    dw03           => < std synopsys dware dw03 dw02 dw01 ieee gtech  >,
    dw04           => < dw04 ieee dw01 dware gtech                    >,
    dw05           => < dw05 ieee dware                               >,
    dw06           => < dw06 ieee dware                               >,
    dw07           => < ieee dware                                    >,
    dware          => < ieee dware                                    >,
    gtech          => < ieee gtech                                    >,
    ramlib         => < std ieee                                      >,
    std_cell_lib   => < ieee std_cell_lib                             >,
    synopsys       => <                                               >;

print_topo_sort(%deps);
%deps<dw01>.push: 'dw04'; # Add unresolvable dependency
print_topo_sort(%deps);

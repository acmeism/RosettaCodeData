sub print_topo_sort ( %deps ) {
    my %ba = %deps.kv».map: * => set;
    %ba{.key}.=union(set .value) if .key ne .value
        for %deps.map: { .key X=> .value }

    while %ba.grep((:!value))».key -> @afters {
        say ~@afters.sort;
        %ba.delete(@afters);
        %ba{*}».=difference(@afters);
    }

    say %ba ?? "Cycle found! {%ba.keys.sort}" !! '---';
}

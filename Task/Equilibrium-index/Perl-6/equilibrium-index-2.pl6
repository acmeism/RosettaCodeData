sub equilibrium_index(@list) {
    my @a = [\+] @list;
    my @b = reverse [\+] reverse @list;
    ^@list Zxx (@a »==« @b);
}

# Show original hashes
say my %base   = :name('Rocket Skates'), :price<12.75>, :color<yellow>;
say my %update = :price<15.25>, :color<red>, :year<1974>;

# Need to assign to anonymous hash to get the desired results and avoid mutating
# TIMTOWTDI
say "\nUpdate:\n", join "\n", sort %=%base, %update;
# Same
say "\nUpdate:\n", {%base, %update}.sort.join: "\n";

say "\nMerge:\n", join "\n", sort ((%=%base).push: %update)».join: ', ';
# Same
say "\nMerge:\n", ({%base}.push: %update)».join(', ').sort.join: "\n";

# Demonstrate unmutated hashes
say "\n", %base, "\n", %update;

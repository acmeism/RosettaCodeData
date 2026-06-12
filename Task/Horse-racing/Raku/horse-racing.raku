my %card;
%card<a> = { name => 'Alberta Clipper',       :sex<M>, rating => 100 };
%card<b> = { name => 'Beetlebaum',            :sex<F>, rating => %card<a><rating> - 8 - 2*2 };
%card<c> = { name => 'Canyonero',             :sex<M>, rating => %card<a><rating> + 4 - 2*3.5 };
%card<d> = { name => 'Donnatello',            :sex<F>, rating => %card<a><rating> - 4 - 10*0.4 };
%card<e> = { name => 'Exterminator',          :sex<M>, rating => %card<d><rating> + 7 - 2*1 };
%card<f> = { name => 'Frequent Flyer',        :sex<M>, rating => %card<d><rating> + 11 - 2*(4-2) };
%card<g> = { name => 'Grindstone',            :sex<M>, rating => %card<a><rating> - 10 + 10*0.2 };
%card<h> = { name => 'His Honor',             :sex<M>, rating => %card<g><rating> + 6 - 2*1.5 };
%card<i> = { name => 'Iphigenia in Brooklyn', :sex<F>, rating => %card<g><rating> + 15 - 2*2 };
%card<j> = { name => 'Josephine',             :sex<F>, rating => Nil };

# adjustments to ratings for current race
%card<b><rating> += 4;
%card<c><rating> -= 4;
%card<h><rating> += 3;
%card<j><rating> = %card<a><rating> - 3 + 10*0.2;

# adjust filly's allowance
# initialize carry weights
for %card {
    .value<rating> += 3 if .value<sex> eq 'F';
    .value<weight> = (.value<sex> eq 'M') ?? 9.00 !! 8.11
}

my ($previous, $position, $leader) = 0;
say "Pos Horse         Name           Weight   Back    Sex    Time";

for %card.sort( -*.value.<rating> ) {
    FIRST $leader = $_;
    ++$position if $previous != .value.<rating>;
    $previous = .value.<rating>;
    .value<back> = ($leader.value<rating> - .value<rating>) / 2;
    .value<time> = 96 - (.value.<rating> - 100) / 10;
    printf "%2d    %s   %-22s  %.2f    %.1f    %-6s %s\n", $position, .key, .value<name>, .value<weight>,
      .value<back>, .value<sex> eq 'M' ?? 'colt' !! 'filly', .value.<time>.polymod(60 xx*).reverse.join: ':';
}

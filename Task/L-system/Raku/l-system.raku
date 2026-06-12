# L-system functionality
role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

# Testing
my $rabbits = 'I' but Lindenmayer({I => 'M', M => 'MI'});

.say for $rabbits++ xx 6;

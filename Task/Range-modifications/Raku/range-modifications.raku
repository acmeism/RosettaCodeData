my @seq;

-> $op, $string { printf "%20s -> %s\n", $op, $string } for
  'Start',     to-string( @seq  = canonicalize "" ),
  'add 77',    to-string( @seq .= &add(77) ),
  'add 79',    to-string( @seq .= &add(79) ),
  'add 78',    to-string( @seq .= &add(78) ),
  'remove 77', to-string( @seq .= &remove(77) ),
  'remove 78', to-string( @seq .= &remove(78) ),
  'remove 79', to-string( @seq .= &remove(79) );

say '';
-> $op, $string { printf "%20s -> %s\n", $op, $string } for
  'Start',    to-string( @seq  = canonicalize "1-3,5-5" ),
  'add 1',    to-string( @seq .= &add(1) ),
  'remove 4', to-string( @seq .= &remove(4) ),
  'add 7',    to-string( @seq .= &add(7) ),
  'add 8',    to-string( @seq .= &add(8) ),
  'add 6',    to-string( @seq .= &add(6) ),
  'remove 7', to-string( @seq .= &remove(7) );

say '';
-> $op, $string { printf "%20s -> %s\n", $op, $string } for
  'Start',     to-string( @seq  = canonicalize "1-5,10-25,27-30" ),
  'add 26',    to-string( @seq .= &add(26) ),
  'add 9',     to-string( @seq .= &add(9) ),
  'add 7',     to-string( @seq .= &add(7) ),
  'remove 26', to-string( @seq .= &remove(26) ),
  'remove 9',  to-string( @seq .= &remove(9) ),
  'remove 7',  to-string( @seq .= &remove(7) );

say '';
-> $op, $string { printf "%30s -> %s\n", $op, $string } for
  'Start',                  to-string( @seq  = canonicalize "6-57,160-251,2700-7000000" ),
  'add "2502-2698"',        to-string( @seq .= &add("2502-2698") ),
  'add 41..69',             to-string( @seq .= &add(41..69) ),
  'remove 17..30',          to-string( @seq .= &remove(17..30) ),
  'remove 4391..6527',      to-string( @seq .= &remove("4391-6527") ),
  'add 2699',               to-string( @seq .= &add(2699) ),
  'add 76',                 to-string( @seq .= &add(76) ),
  'add 78',                 to-string( @seq .= &add(78) ),
  'remove "70-165"',        to-string( @seq .= &remove("70-165") ),
  'remove 16..31',          to-string( @seq .= &remove(16..31) ),
  'add 1.417e16 .. 3.2e21', to-string( @seq .= &add(1.417e16.Int .. 3.2e21.Int) ),
  'remove "4001-Inf"',      to-string( @seq .= &remove("4001-Inf") );


sub canonicalize (Str $ranges) { sort consolidate |sort parse-range $ranges }

sub parse-range (Str $_) { .comb(/\d+|'Inf'/).map: { +$^α .. +$^ω } }

sub to-string (@ranges) { qq|"{ @ranges».minmax».join('-').join(',') }"| }

multi add (@ranges, Int   $i) { samewith @ranges, $i .. $i }
multi add (@ranges, Str   $s) { samewith @ranges, |parse-range($s) }
multi add (@ranges, Range $r) { @ranges > 0 ?? (sort consolidate |sort |@ranges, $r) !! $r }

multi remove (@ranges, Int   $i) { samewith @ranges, $i .. $i }
multi remove (@ranges, Str   $s) { samewith @ranges, |parse-range($s) }
multi remove (@ranges, Range $r) {
    gather for |@ranges -> $this {
        if $r.min <= $this.min {
            if $r.max >= $this.min and $r.max < $this.max {
                take $r.max + 1 .. $this.max
            }
            elsif $r.max < $this.min {
                take $this
            }
        }
        else {
            if $r.max >= $this.max and $r.min <= $this.max {
                take $this.min .. $r.min - 1
            }
            elsif $r.max < $this.max and $r.min > $this.min {
                take $this.min .. $r.min - 1;
                take $r.max + 1 .. $this.max
            }
            else {
                take $this
            }
        }
    }
}

multi consolidate() { () }

multi consolidate($this is copy, **@those) {
    sub infix:<∪> (Range $a, Range $b) { Range.new($a.min,max($a.max,$b.max)) }

    sub infix:<∩> (Range $a, Range $b) { so $a.max >= $b.min }

    my @ranges = sort gather {
        for consolidate |@those -> $that {
            next unless $that;
            if $this ∩ $that { $this ∪= $that }
            else             { take $that }
        }
        take $this;
    }
    for reverse ^(@ranges - 1) {
        if @ranges[$_].max == @ranges[$_ + 1].min - 1 {
            @ranges[$_] = @ranges[$_].min .. @ranges[$_ + 1].max;
            @ranges[$_ + 1]:delete
        }
    }
    @ranges
}

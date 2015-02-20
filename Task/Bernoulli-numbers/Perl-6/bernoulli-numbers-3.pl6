my sub infix:<bop>(\prev,\this) { this.key => this.key * (this.value - prev.value) }

constant bernoulli = grep *.value, map { (.key => .value.[*-1]) }, do
        0 => [FatRat.new(1,1)],
        -> (:key($pm),:value(@pa)) {
             $pm + 1 => [ map *.value, [\bop] ($pm + 2 ... 1) Z=> FatRat.new(1, $pm + 2), @pa ];
        } ... *;

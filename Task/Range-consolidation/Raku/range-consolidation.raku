# Union
sub infix:<∪> (Range $a, Range $b) { Range.new($a.min,max($a.max,$b.max)) }

# Intersection
sub infix:<∩> (Range $a, Range $b) { so $a.max >= $b.min }

multi consolidate() { () }

multi consolidate($this is copy, **@those) {
    gather {
        for consolidate |@those -> $that {
            if $this ∩ $that { $this ∪= $that }
            else             { take $that }
        }
        take $this;
    }
}

for [[1.1, 2.2],],
    [[6.1, 7.2], [7.2, 8.3]],
    [[4, 3], [2, 1]],
    [[4, 3], [2, 1], [-1, -2], [3.9, 10]],
    [[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]]
-> @intervals {
    printf "%46s => ", @intervals.raku;
    say reverse consolidate |@intervals.grep(*.elems)».sort.sort({ [.[0], .[*-1]] }).map: { Range.new(.[0], .[*-1]) }
}

multi suffix-tree(Str $str) { suffix-tree flat map &flip, [\~] $str.flip.comb }
multi suffix-tree(@a) {
    hash
    @a == 0 ?? () !!
    @a == 1 ?? ( @a[0] => [] ) !!
    gather for @a.classify(*.substr(0, 1)) {
        my $subtree = suffix-tree(grep *.chars, map *.substr(1), .value[]);
        if $subtree == 1 {
            my $pair = $subtree.pick;
            take .key ~ $pair.key => $pair.value;
        } else {
            take .key => $subtree;
        }
    }
}

my $tree = root => suffix-tree 'banana$';

.say for visualize-tree $tree, *.key, *.value.List;

sub visualize-tree($tree, &label, &children,
                   :$indent = '',
                   :@mid = ('├─', '│ '),
                   :@end = ('└─', '  '),
) {
    sub visit($node, *@pre) {
        gather {
            take @pre[0] ~ $node.&label;
            my @children = sort $node.&children;
            my $end = @children.end;
            for @children.kv -> $_, $child {
                when $end { take visit($child, (@pre[1] X~ @end)) }
                default   { take visit($child, (@pre[1] X~ @mid)) }
            }
        }
    }
    flat visit($tree, $indent xx 2);
}

sub visualize-tree($tree, &label, &children,
                   :$indent = '',
                   :@mid = ('├─', '│ '),
                   :@end = ('└─', '  '),
) {
    sub visit($node, *@pre) {
        | gather {
            take @pre[0] ~ label($node);
            my @children := children($node);
            my $end = @children.end;
            for @children.kv -> $_, $child {
                when $end { take visit($child, (@pre[1] X~ @end)) }
                default   { take visit($child, (@pre[1] X~ @mid)) }
            }
        }
    }
    visit($tree, $indent xx 2);
}

# example tree built up of pairs
my $tree = root=>[a=>[a1=>[a11=>[]]],b=>[b1=>[b11=>[]],b2=>[],b3=>[]]];

.map({.join("\n")}).join("\n").say for visualize-tree($tree, *.key, *.value.list);

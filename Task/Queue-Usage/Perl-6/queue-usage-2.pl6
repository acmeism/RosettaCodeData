my @queue = < a >;

@queue.push('b', 'c'); # [ a, b, c ]

say @queue.shift; # a
say @queue.pop; # c

say @queue.perl; # [ b ]
say @queue.elems; # 1

@queue.unshift('A'); # [ A, b ]
@queue.push('C'); # [ A, b, C ]

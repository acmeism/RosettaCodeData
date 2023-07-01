constant %dict = 'unixdict.txt'.IO.lines
                               .classify(*.chars)
                               .map({ .key => .value.Set });

sub word_ladder ( Str $from, Str $to ) {
    die if $from.chars != $to.chars;

    my $sized_dict = %dict{$from.chars};

    my @workqueue = (($from,),);
    my $used = ($from => True).SetHash;
    while @workqueue {
        my @new_q;
        for @workqueue -> @words {
            my $last_word = @words.tail;
            my @new_tails = gather for 'a' .. 'z' -> $replacement_letter {
                for ^$last_word.chars -> $i {
                    my $new_word = $last_word;
                    $new_word.substr-rw($i, 1) = $replacement_letter;

                    next unless $new_word ∈ $sized_dict
                        and not $new_word ∈ $used;
                    take $new_word;
                    $used{$new_word} = True;

                    return |@words, $new_word if $new_word eq $to;
                }
            }
            push @new_q, ( |@words, $_ ) for @new_tails;
        }
        @workqueue = @new_q;
    }
}
for <boy man>, <girl lady>, <john jane>, <child adult> -> ($from, $to) {
    say word_ladder($from, $to)
        // "$from into $to cannot be done";
}

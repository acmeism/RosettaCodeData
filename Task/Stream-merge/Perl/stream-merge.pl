use strict;
use warnings;
use English;
use String::Tokenizer;
use Heap::Simple;

my $stream1 = <<"END_STREAM_1";
Integer vel neque ligula. Etiam a ipsum a leo eleifend viverra sit amet ac
arcu. Suspendisse odio libero, ullamcorper eu sem vitae, gravida dignissim
ipsum. Aenean tincidunt commodo feugiat. Nunc viverra dolor a tincidunt porta.
Ut malesuada quis mauris eget vestibulum. Fusce sit amet libero id augue mattis
auctor et sit amet ligula.
END_STREAM_1

my $stream2 = <<"END_STREAM_2";
In luctus odio nulla, ut finibus elit aliquet in. In auctor vitae purus quis
tristique. Mauris sed erat pulvinar, venenatis lectus auctor, malesuada neque.
Integer a hendrerit tortor. Suspendisse aliquet pellentesque lorem, nec tincidunt
arcu aliquet non. Phasellus eu diam massa. Integer vitae volutpat augue. Nulla
condimentum consectetur ante, ut consequat lectus suscipit eget.
END_STREAM_2

my $stream3 = <<"END_STREAM_3";
In hendrerit eleifend mi nec ultricies. Vestibulum euismod, tellus sit amet
eleifend ultrices, velit nisi dignissim lectus, non vestibulum sem nisi sed mi.
Nulla scelerisque ut purus sed ultricies. Donec pulvinar eleifend malesuada. In
viverra faucibus enim a luctus. Vivamus tellus erat, congue quis quam in, lobortis
varius mi. Nulla ante orci, porttitor id dui ac, iaculis consequat ligula.
END_STREAM_3

my $stream4 = <<"END_STREAM_4";
Suspendisse elementum nunc ex, ac pulvinar mauris finibus sed. Ut non ex sed tortor
ultricies feugiat non at eros. Donec et scelerisque est. In vestibulum fringilla
metus eget varius. Aenean fringilla pellentesque massa, non ullamcorper mi commodo
non. Sed aliquam molestie congue. Nunc lobortis turpis at nunc lacinia, id laoreet
ipsum bibendum.
END_STREAM_4

my $stream5 = <<"END_STREAM_5";
Donec sit amet urna nulla. Duis nec consectetur lacus, et viverra ex. Aliquam
lobortis tristique hendrerit. Suspendisse viverra vehicula lorem id gravida.
Pellentesque at ligula lorem. Cras gravida accumsan lacus sit amet tincidunt.
Curabitur quam nisi, viverra vel nulla vel, rhoncus facilisis massa. Aliquam
erat volutpat.
END_STREAM_5

my $stream6 = <<"END_STREAM_6";
Curabitur nec enim eu nisi maximus suscipit rutrum non sem. Donec lobortis nulla
et rutrum bibendum. Duis varius, tellus in commodo gravida, lorem neque finibus
quam, sagittis elementum leo mauris sit amet justo. Sed vestibulum velit eget
sapien bibendum, sit amet porta lorem fringilla. Morbi bibendum in turpis ac
blandit. Mauris semper nibh nec dignissim dapibus. Proin sagittis lacus est.
END_STREAM_6

merge_two_streams(map {String::Tokenizer->new($ARG)->iterator()}
                      ($stream1, $stream2));
merge_N_streams(6, map {String::Tokenizer->new($ARG)->iterator()}
                       ($stream1, $stream2, $stream3,
                        $stream4, $stream5, $stream6));
exit 0;

sub merge_two_streams {
    my ($iter1, $iter2) = @ARG;
    print "Merge of 2 streams:\n";
    while (1) {
        if (!$iter1->hasNextToken() && !$iter2->hasNextToken()) {
            print "\n\n";
            last;
        }
        elsif (!$iter1->hasNextToken()) {
            print $iter2->nextToken(), q{ };
        }
        elsif (!$iter2->hasNextToken()) {
            print $iter1->nextToken(), q{ };
        }
        elsif ($iter1->lookAheadToken() lt $iter2->lookAheadToken()) {
            print $iter1->nextToken(), q{ };
        }
        else {
            print $iter2->nextToken(), q{ };
        }
    }
    return;
}

sub merge_N_streams {
    my $N = shift;
    print "Merge of $N streams:\n";
    my @iters = @ARG;
    my $heap = Heap::Simple->new(order => 'lt', elements => 'Array');
    for (my $i=0; $i<$N; $i++) {
        my $iter = $iters[$i];
        $iter->hasNextToken() or die "Each stream must have >= 1 element";
        $heap->insert([$iter->nextToken() . q{ }, $i]);
    }
    $heap->count == $N or die "Problem with initial population of heap";
    while (1) {
        my ($token, $iter_idx) = @{ $heap->extract_top };
        print $token;
        # Attempt to read the next element from the same iterator where we
        # obtained the element we just extracted.
        my $to_insert = _fetch_next_element($iter_idx, $N, @iters);
        if (! $to_insert) {
            print join('', map {$ARG->[0]} $heap->extract_all);
            last;
        }
        $heap->insert($to_insert);
    }
    return;
}

sub _fetch_next_element {
    my $starting_idx = shift; my $N = shift; my @iters = @ARG;
    # Go round robin through every iterator exactly once, returning the first
    # element on offer.
    my @round_robin_idxs =
        map {$ARG % $N} ($starting_idx .. $starting_idx + $N - 1);
    foreach my $iter_idx (@round_robin_idxs) {
        my $iter = $iters[$iter_idx];
        if ($iter->hasNextToken()) {
            return [$iter->nextToken() . q{ }, $iter_idx];
        }
    }
    # At this point every iterator has been exhausted.
    return;
}

sub cat ($fname) { lazy $fname.IO.lines };
sub head ($count, @positional) { @positional.head($count) }
sub redirect ($fname) { cat($fname) }
sub tail (Int $count, Str $fname) { $fname.IO.lines.tail($count) }
sub infix:<tee> ($stream, $fname) {
    # need to reify the lazy list to write to a file
    my @values = @$stream[^Inf].grep: *.defined;
    # meh. not really going to write the files
    # $fname.IO.put @values.join("\n")
    # just pass the reified values along
    @values.List
}

my $aa = ((
    (head 4, redirect 'List_of_computer_scientists.lst'),
    cat('List_of_computer_scientists.lst') .grep( /'ALGOL'/ ) tee 'ALGOL_pioneers.lst',
    tail 4, 'List_of_computer_scientists.lst'
).flat .sort .unique tee 'the_important_scientists.lst') .grep: /'aa'/;

say "Pioneer: $aa";

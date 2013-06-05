use JSON::Tiny;
sub MAIN ( Str $language = 'Perl_6' ) {
    my @done_tasks = set tasks($language);
    my @all_tasks  = set tasks('Programming_Tasks');
    .say for @all_tasks (-) @done_tasks;
}

sub url_of ( Str $category, Str $continue? ) {
    my $cat = $category.subst( /<-[ A..Z a..z 0..9 . ~ _ - ]>/,
        *.ord.fmt('%%%02X'), :g );

    return 'http://rosettacode.org/mw/api.php?action=query&cmlimit=500'
         ~ "&format=json&list=categorymembers&cmtitle=Category:$cat"
         ~ ("&cmcontinue=$continue" if $continue);
}

sub get_mirrored_page ( Str $url, Str $filename ) {
    if $filename.IO !~~ :e or (now - $filename.IO.modified) > 3600 {
        run('curl', '-sSo', $filename, $url) or die;
    }
    return slurp $filename;
}

sub tasks ( Str $category ) {
    my $continue = '';
    my @tasks = gather for 1..* -> $page_num {
        my $href = from-json get_mirrored_page(
             url_of( $category, $continue ),
             "{$category}_{$page_num}.json",
        );

        take map *.<title>, $href.<query>.<categorymembers>.list;

        $continue = $href.<query-continue>.<categorymembers>.<cmcontinue>
            or last;
    } or die "Nothing found for category '$category'";

    return @tasks;
}

use Digest::SHA256::Native;

sub MAIN( $dir = '.', :$minsize = 5, :$recurse = True ) {
    my %files;
    my @dirs = $dir.IO.absolute.IO;
    while @dirs {
        my @files = @dirs.pop;
        while @files {
            for @files.pop.dir -> $path {
                %files{ $path.s }.push: $path if $path.f and $path.s >= $minsize;
                @dirs.push: $path if $path.d and $path.r and $recurse
            }
        }
    }

    for %files.sort( +*.key ).grep( *.value.elems > 1)».kv -> ($size, @list) {
        my %dups;
        @list.map: { %dups{ sha256-hex( ($_.slurp :bin).decode ) }.push: $_.Str };
        for %dups.grep( *.value.elems > 1)».value -> @dups {
            say sprintf("%9s : ", scale $size ),  @dups.join(', ');
        }
    }
}

sub scale ($bytes) {
    given $bytes {
        when $_ < 2**10 {  $bytes                    ~ ' B'  }
        when $_ < 2**20 { ($bytes / 2**10).round(.1) ~ ' KB' }
        when $_ < 2**30 { ($bytes / 2**20).round(.1) ~ ' MB' }
        default         { ($bytes / 2**30).round(.1) ~ ' GB' }
    }
}

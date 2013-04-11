my %licenses;

%licenses<count max> = 0,0;

for $*IN.lines -> $line {
    my ( $license, $date_time );
    ( *, $license, *, $date_time ) = split /\s+/, $line;
    if $license eq 'OUT' {
        %licenses<count>++;
        if %licenses<count> > %licenses<max> {
            %licenses<max>   = %licenses<count>;
            %licenses<times> = [$date_time];
        }
        elsif %licenses<count> == %licenses<max> {
            %licenses<times>.push($date_time);
        }
    }
    else {
        if %licenses<count> == %licenses<max> {
            %licenses<times>[*-1] ~= " through " ~ $date_time;
        }
        %licenses<count>--;
    }
};

my $plural = %licenses<times>.elems == 1 ?? '' !! 's';

say "Maximum concurrent licenses in use: {%licenses<max>}, in the time period{$plural}:";
say join ",\n", %licenses<times>.list;

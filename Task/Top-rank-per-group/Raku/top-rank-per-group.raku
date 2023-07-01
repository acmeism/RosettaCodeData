my @data = do for q:to/---/.lines -> $line {
        E10297  32000   D101    Tyler Bennett
        E21437  47000   D050    John Rappl
        E00127  53500   D101    George Woltman
        E63535  18000   D202    Adam Smith
        E39876  27800   D202    Claire Buckman
        E04242  41500   D101    David McClellan
        E01234  49500   D202    Rich Holcomb
        E41298  21900   D050    Nathan Adams
        E43128  15900   D101    Richard Potter
        E27002  19250   D202    David Motsinger
        E03033  27000   D101    Tim Sampair
        E10001  57000   D190    Kim Arlich
        E16398  29900   D190    Timothy Grove
        ---

  $%( < Id      Salary  Dept    Name >
      Z=>
      $line.split(/ \s\s+ /)
    )
}

sub MAIN(Int $N = 3) {
    for @data.classify({ .<Dept> }).sort».value {
        my @es = .sort: { -.<Salary> }
        say '' if (state $bline)++;
        say .< Dept Id Salary Name > for @es[^$N]:v;
    }
}
